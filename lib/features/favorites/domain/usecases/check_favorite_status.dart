import 'package:injectable/injectable.dart';
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';

@injectable
class CheckFavoriteStatus {
  const CheckFavoriteStatus(this.repository);

  final FavoriteRepository repository;

  Future<bool> call(String mealId) async {
    return repository.isFavorite(mealId);
  }
}
