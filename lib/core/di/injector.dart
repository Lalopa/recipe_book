import 'package:get_it/get_it.dart';
import 'package:recipe_book/core/di/dio_config.dart';
import 'package:recipe_book/core/di/objectbox_config.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_local_datasource.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_rest_provider.dart';
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/domain/usecases/search_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  await ObjectBoxConfig.initObjectBox();

  getIt
    ..registerLazySingleton(DioConfig.createDio)
    // Data
    ..registerLazySingleton<MealRemoteDataSource>(
      () => MealRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<MealLocalDataSource>(
      MealLocalDataSourceImpl.new,
    )
    // Repositories
    ..registerLazySingleton<MealRepository>(
      () => MealRepositoryImpl(getIt(), getIt()),
    )
    // Usecase
    ..registerLazySingleton(() => GetMealsByLetter(getIt()))
    ..registerLazySingleton(() => SearchMeals(getIt()))
    // Bloc
    ..registerFactory(() => MealBloc(getIt()))
    ..registerFactory(() => SearchBloc(getIt()))
    // Cubit
    ..registerFactory(MainCubit.new);
}
