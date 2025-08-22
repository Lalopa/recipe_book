import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl();

  @override
  Future<List<Meal>> getMealsByLetter(String letter) async {
    return [];
  }
}
