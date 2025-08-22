import 'package:recipe_book/features/meals/domain/entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getMealsByLetter(String letter);

  Future<List<Meal>> searchMeals(String query);
}
