import 'package:recipe_book/features/meals/domain/entities/meal.dart';

// This abstract class will be completed later
// ignore: one_member_abstracts
abstract class MealRepository {
  Future<List<Meal>> getMealsByLetter(String letter);
}
