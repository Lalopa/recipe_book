import 'package:recipe_book/features/meals/domain/entities/meal.dart';

abstract class FavoriteRepository {
  Future<void> toggleFavorite(String mealId);

  Future<List<Meal>> getFavoriteMeals();

  Future<bool> isFavorite(String mealId);
}
