import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

void main() {
  group('Dependency Injection', () {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await GetIt.instance.reset();
      await initDependencies();
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

    test('should handle multiple initialization calls', () async {
      expect(GetIt.instance.isRegistered<MealRemoteDataSource>(), isTrue);
      expect(GetIt.instance.isRegistered<MealRepository>(), isTrue);
      expect(GetIt.instance.isRegistered<GetMealsByLetter>(), isTrue);
      expect(GetIt.instance.isRegistered<MealBloc>(), isTrue);
      expect(GetIt.instance.isRegistered<MainCubit>(), isTrue);
    });
  });
}
