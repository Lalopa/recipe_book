import 'package:recipe_book/features/meals/data/models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> fetchByLetter(String letter);

  Future<List<MealModel>> searchMeals(String query);
}
