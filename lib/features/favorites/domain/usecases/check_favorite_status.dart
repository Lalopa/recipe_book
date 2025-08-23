import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';

class CheckFavoriteStatus {
  const CheckFavoriteStatus(this.repository);

  final FavoriteRepository repository;

  Future<bool> call(String mealId) async {
    return repository.isFavorite(mealId);
  }
}
