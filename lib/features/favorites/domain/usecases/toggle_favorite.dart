import 'package:injectable/injectable.dart';
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';

@injectable
class ToggleFavorite {
  const ToggleFavorite(this.repository);

  final FavoriteRepository repository;

  Future<void> call(String mealId) async {
    await repository.toggleFavorite(mealId);
  }
}
