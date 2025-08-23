import 'package:recipe_book/features/favorites/data/datasources/favorite_local_datasource.dart';
import 'package:recipe_book/features/favorites/data/models/favorite_meal_model.dart';
import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  const FavoriteRepositoryImpl(this.localDataSource);

  final FavoriteLocalDataSource localDataSource;

  @override
  Future<void> toggleFavorite(String mealId) async {
    await localDataSource.toggleFavorite(mealId);
  }

  @override
  Future<List<FavoriteMeal>> getFavoriteMeals() async {
    final models = await localDataSource.getFavoriteMeals();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<bool> isFavorite(String mealId) async {
    return localDataSource.isFavorite(mealId);
  }
}
