import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

class GetFavoriteMeals {
  const GetFavoriteMeals(this.repository);

  final FavoriteRepository repository;

  Future<List<Meal>> call() async {
    return repository.getFavoriteMeals();
  }
}
