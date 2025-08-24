import 'package:injectable/injectable.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_local_datasource.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';

@Injectable(as: MealRepository)
class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl(this.remoteDataSource, this.localDataSource);

  final MealRemoteDataSource remoteDataSource;
  final MealLocalDataSource localDataSource;

  @override
  Future<List<Meal>> getMealsByLetter(String letter) async {
    final cachedModels = await localDataSource.getCachedMealsByLetter(letter);
    if (cachedModels != null && cachedModels.isNotEmpty) {
      return cachedModels.map((m) => m.toEntity()).toList();
    }

    final models = await remoteDataSource.fetchByLetter(letter);

    if (models.isNotEmpty) {
      await localDataSource.cacheMealsByLetter(letter, models);
    }

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Meal>> searchMeals(String query) async {
    final cachedModels = await localDataSource.getCachedSearchResults(query);
    if (cachedModels != null && cachedModels.isNotEmpty) {
      return cachedModels.map((m) => m.toEntity()).toList();
    }

    final models = await remoteDataSource.searchMeals(query);

    if (models.isNotEmpty) {
      await localDataSource.cacheSearchResults(query, models);
    }

    return models.map((m) => m.toEntity()).toList();
  }
}
