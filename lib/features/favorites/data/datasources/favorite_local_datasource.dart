import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/features/favorites/data/models/favorite_meal_model.dart';

abstract class FavoriteLocalDataSource {
  Future<void> toggleFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
  Future<List<FavoriteMealModel>> getFavoriteMeals();
}

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
  Future<List<FavoriteMealModel>> getFavoriteMeals() async {
    return _cache.getFavoriteMeals();
  }
}
