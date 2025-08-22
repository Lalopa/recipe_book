import 'package:recipe_book/features/meals/data/models/meal_model.dart';

// This abstract class will be completed later
// ignore: one_member_abstracts
abstract class MealRemoteDataSource {
  Future<List<MealModel>> fetchByLetter(String letter);
}
