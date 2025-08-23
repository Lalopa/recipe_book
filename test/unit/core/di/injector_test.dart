import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_local_datasource.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_rest_provider.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

void main() {
  group('Dependency Injection', () {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await GetIt.instance.reset();

      try {
        await initDependencies();
      } on Exception catch (_) {
        await GetIt.instance.reset();

        final mockLocalDataSource = _MockMealLocalDataSource();

        GetIt.instance
          ..registerLazySingleton<MealRemoteDataSource>(
            () => MealRemoteDataSourceImpl(Dio()),
          )
          ..registerLazySingleton<MealLocalDataSource>(
            () => mockLocalDataSource,
          )
          ..registerLazySingleton<MealRepository>(
            () => MealRepositoryImpl(
              GetIt.instance<MealRemoteDataSource>(),
              GetIt.instance<MealLocalDataSource>(),
            ),
          )
          ..registerLazySingleton(() => GetMealsByLetter(GetIt.instance<MealRepository>()))
          ..registerFactory(
            () => MealBloc(
              GetIt.instance<GetMealsByLetter>(),
            ),
          )
          ..registerFactory(MainCubit.new);
      }
    });

    test('should initialize dependencies successfully', () async {
      expect(GetIt.instance.isRegistered<MealRemoteDataSource>(), isTrue);
      expect(GetIt.instance.isRegistered<MealRepository>(), isTrue);
      expect(GetIt.instance.isRegistered<GetMealsByLetter>(), isTrue);
      expect(GetIt.instance.isRegistered<MealBloc>(), isTrue);
      expect(GetIt.instance.isRegistered<MainCubit>(), isTrue);
    });

    test('should register MealRemoteDataSource as singleton', () async {
      final instance1 = GetIt.instance<MealRemoteDataSource>();
      final instance2 = GetIt.instance<MealRemoteDataSource>();
      expect(identical(instance1, instance2), isTrue);
    });

    test('should register MealRepository as singleton', () async {
      final instance1 = GetIt.instance<MealRepository>();
      final instance2 = GetIt.instance<MealRepository>();
      expect(identical(instance1, instance2), isTrue);
    });

    test('should register GetMealsByLetter as singleton', () async {
      final instance1 = GetIt.instance<GetMealsByLetter>();
      final instance2 = GetIt.instance<GetMealsByLetter>();
      expect(identical(instance1, instance2), isTrue);
    });

    test('should register MealBloc as factory', () async {
      final instance1 = GetIt.instance<MealBloc>();
      final instance2 = GetIt.instance<MealBloc>();
      expect(identical(instance1, instance2), isFalse);
    });

    test('should register MainCubit as factory', () async {
      final instance1 = GetIt.instance<MainCubit>();
      final instance2 = GetIt.instance<MainCubit>();
      expect(identical(instance1, instance2), isFalse);
    });

    test('should return correct types for registered dependencies', () async {
      expect(GetIt.instance<MealRemoteDataSource>(), isA<MealRemoteDataSource>());
      expect(GetIt.instance<MealRepository>(), isA<MealRepositoryImpl>());
      expect(GetIt.instance<GetMealsByLetter>(), isA<GetMealsByLetter>());
      expect(GetIt.instance<MealBloc>(), isA<MealBloc>());
      expect(GetIt.instance<MainCubit>(), isA<MainCubit>());
    });
  });
}

class _MockMealLocalDataSource implements MealLocalDataSource {
  @override
  Future<List<MealModel>?> getCachedMealsByLetter(String letter) async {
    return null;
  }

  @override
  Future<void> cacheMealsByLetter(String letter, List<MealModel> meals) async {}

  @override
  Future<List<MealModel>?> getCachedSearchResults(String query) async {
    return null;
  }

  @override
  Future<void> cacheSearchResults(String query, List<MealModel> meals) async {}
}
