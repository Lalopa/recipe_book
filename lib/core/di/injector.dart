import 'package:get_it/get_it.dart';
import 'package:recipe_book/core/di/dio_config.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_rest_provider.dart';
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt
    ..registerLazySingleton(DioConfig.createDio)
    // Data
    ..registerLazySingleton<MealRemoteDataSource>(
      () => MealRemoteDataSourceImpl(getIt()),
    )
    // Repositories
    ..registerLazySingleton<MealRepository>(
      () => MealRepositoryImpl(getIt()),
    )
    // Usecase
    ..registerLazySingleton(() => GetMealsByLetter(getIt()))
    // Bloc
    ..registerFactory(() => MealBloc(getIt()))
    // Cubit
    ..registerFactory(MainCubit.new);
}
