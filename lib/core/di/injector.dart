import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt
    ..registerLazySingleton(Dio.new)
    // Repositories
    ..registerLazySingleton<MealRepository>(
      MealRepositoryImpl.new,
    )
    // Usecase
    ..registerLazySingleton(() => GetMealsByLetter(getIt()))
    // Bloc
    ..registerFactory(() => MealBloc(getIt()))
    // Cubit
    ..registerFactory(MainCubit.new);
}
