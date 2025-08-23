import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/features/favorites/data/models/favorite_meal_model.dart';

abstract class FavoriteLocalDataSource {
  Future<void> toggleFavorite(String mealId);

  Future<void> setFavorite({required String mealId, required bool isFavorite});

  Future<List<FavoriteMealModel>> getFavoriteMeals();

  Future<bool> isFavorite(String mealId);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  final ObjectBoxCacheManager _cache = ObjectBoxCacheManager.instance;

  @override
  Future<void> toggleFavorite(String mealId) async {
    await _cache.toggleFavorite(mealId);
  }

  @override
  Future<void> setFavorite({required String mealId, required bool isFavorite}) async {
    await _cache.setFavorite(mealId: mealId, isFavorite: isFavorite);
  }

  @override
  Future<List<FavoriteMealModel>> getFavoriteMeals() async {
    return _cache.getFavoriteMeals();
  }

  @override
  Future<bool> isFavorite(String mealId) async {
    return _cache.isFavorite(mealId);
  }
}
