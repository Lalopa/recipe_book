import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';

abstract class FavoriteRepository {
  Future<void> toggleFavorite(String mealId);

  Future<List<FavoriteMeal>> getFavoriteMeals();

  Future<bool> isFavorite(String mealId);
}
