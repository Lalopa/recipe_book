import 'package:injectable/injectable.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';

@injectable
class SearchMeals {
  SearchMeals(this.repository);

  final MealRepository repository;

  Future<List<Meal>> call(String query) => repository.searchMeals(query);
}
