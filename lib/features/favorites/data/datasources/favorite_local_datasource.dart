import 'package:injectable/injectable.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/core/error/error.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

abstract class FavoriteLocalDataSource {
  Future<void> toggleFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
  Future<List<MealModel>> getFavoriteMeals();
}

@Injectable(as: FavoriteLocalDataSource)
class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  FavoriteLocalDataSourceImpl(this._cache);
  final ObjectBoxCacheManager _cache;

  @override
  Future<void> toggleFavorite(String mealId) async {
    try {
      await _cache.toggleFavorite(mealId);
    } on Exception catch (_) {
      throw const LocalDatabaseFailure('Database not initialized');
    }
  }

  @override
  Future<bool> isFavorite(String mealId) async {
    try {
      return _cache.isFavorite(mealId);
    } on Exception catch (_) {
      throw const LocalDatabaseFailure('Database not initialized');
    }
  }

  @override
  Future<List<MealModel>> getFavoriteMeals() async {
    try {
      return _cache.getFavoriteMeals();
    } on Exception catch (_) {
      throw const LocalDatabaseFailure('Database not initialized');
    }
  }
}
