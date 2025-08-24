import 'package:injectable/injectable.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
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
    await _cache.toggleFavorite(mealId);
  }

  @override
  Future<bool> isFavorite(String mealId) async {
    return _cache.isFavorite(mealId);
  }

  @override
  Future<List<MealModel>> getFavoriteMeals() async {
    return _cache.getFavoriteMeals();
  }
}
