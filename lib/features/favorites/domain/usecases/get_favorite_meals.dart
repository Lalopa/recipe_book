import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';

class GetFavoriteMeals {
  const GetFavoriteMeals(this.repository);

  final FavoriteRepository repository;

  Future<List<FavoriteMeal>> call() async {
    return repository.getFavoriteMeals();
  }
}
