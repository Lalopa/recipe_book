import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl(this.remoteDataSource);

  final MealRemoteDataSource remoteDataSource;

  @override
  Future<List<Meal>> getMealsByLetter(String letter) async {
    final models = await remoteDataSource.fetchByLetter(letter);
    return models.map((m) => m.toEntity()).toList();
  }
}
