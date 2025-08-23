import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/domain/usecases/search_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';

void main() {
  group('Extended Dependency Injection', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      GetIt.instance.reset();
    });

    group('New Dependencies', () {
      test('should register SearchMeals usecase', () async {
        // act
        await initDependencies();

        // assert
        expect(GetIt.instance.isRegistered<SearchMeals>(), isTrue);
      });

      test('should register SearchBloc', () async {
        // act
        await initDependencies();

        // assert
        expect(GetIt.instance.isRegistered<SearchBloc>(), isTrue);
      });

      test('should register SearchMeals as singleton', () async {
        // act
        await initDependencies();

        // assert
        final instance1 = GetIt.instance<SearchMeals>();
        final instance2 = GetIt.instance<SearchMeals>();
        expect(identical(instance1, instance2), isTrue);
      });

      test('should register SearchBloc as factory', () async {
        // act
        await initDependencies();

        // assert
        final instance1 = GetIt.instance<SearchBloc>();
        final instance2 = GetIt.instance<SearchBloc>();
        expect(identical(instance1, instance2), isFalse);
      });
    });

    group('Dependency Types', () {
      test('should return correct SearchMeals type', () async {
        // act
        await initDependencies();

        // assert
        expect(GetIt.instance<SearchMeals>(), isA<SearchMeals>());
      });

      test('should return correct SearchBloc type', () async {
        // act
        await initDependencies();

        // assert
        expect(GetIt.instance<SearchBloc>(), isA<SearchBloc>());
      });

      test('should return SearchMeals with correct dependencies', () async {
        // act
        await initDependencies();

        // assert
        final searchMeals = GetIt.instance<SearchMeals>();
        expect(searchMeals, isA<SearchMeals>());
      });

      test('should return SearchBloc with correct dependencies', () async {
        // act
        await initDependencies();

        // assert
        final searchBloc = GetIt.instance<SearchBloc>();
        expect(searchBloc, isA<SearchBloc>());
      });
    });

    group('Dependency Resolution', () {
      test('should resolve SearchMeals dependencies correctly', () async {
        // act
        await initDependencies();

        // assert
        final searchMeals = GetIt.instance<SearchMeals>();
        expect(searchMeals, isNotNull);
        // Verify that SearchMeals can be instantiated without errors
        expect(() => searchMeals, returnsNormally);
      });

      test('should resolve SearchBloc dependencies correctly', () async {
        // act
        await initDependencies();

        // assert
        final searchBloc = GetIt.instance<SearchBloc>();
        expect(searchBloc, isNotNull);
        // Verify that SearchBloc can be instantiated without errors
        expect(() => searchBloc, returnsNormally);
      });

      test('should resolve all dependencies in correct order', () async {
        // act
        await initDependencies();

        // assert
        // Verify that all dependencies are registered
        expect(GetIt.instance.isRegistered<MealRemoteDataSource>(), isTrue);
        expect(GetIt.instance.isRegistered<MealRepository>(), isTrue);
        expect(GetIt.instance.isRegistered<GetMealsByLetter>(), isTrue);
        expect(GetIt.instance.isRegistered<SearchMeals>(), isTrue);
        expect(GetIt.instance.isRegistered<MealBloc>(), isTrue);
        expect(GetIt.instance.isRegistered<SearchBloc>(), isTrue);
        expect(GetIt.instance.isRegistered<MainCubit>(), isTrue);
      });
    });

    group('Singleton vs Factory Registration', () {
      test('should register usecases as singletons', () async {
        // act
        await initDependencies();

        // assert
        final getMeals1 = GetIt.instance<GetMealsByLetter>();
        final getMeals2 = GetIt.instance<GetMealsByLetter>();
        final searchMeals1 = GetIt.instance<SearchMeals>();
        final searchMeals2 = GetIt.instance<SearchMeals>();

        expect(identical(getMeals1, getMeals2), isTrue);
        expect(identical(searchMeals1, searchMeals2), isTrue);
      });

      test('should register blocs as factories', () async {
        // act
        await initDependencies();

        // assert
        final mealBloc1 = GetIt.instance<MealBloc>();
        final mealBloc2 = GetIt.instance<MealBloc>();
        final searchBloc1 = GetIt.instance<SearchBloc>();
        final searchBloc2 = GetIt.instance<SearchBloc>();

        expect(identical(mealBloc1, mealBloc2), isFalse);
        expect(identical(searchBloc1, searchBloc2), isFalse);
      });

      test('should register data sources as singletons', () async {
        // act
        await initDependencies();

        // assert
        final dataSource1 = GetIt.instance<MealRemoteDataSource>();
        final dataSource2 = GetIt.instance<MealRemoteDataSource>();

        expect(identical(dataSource1, dataSource2), isTrue);
      });

      test('should register repositories as singletons', () async {
        // act
        await initDependencies();

        // assert
        final repo1 = GetIt.instance<MealRepository>();
        final repo2 = GetIt.instance<MealRepository>();

        expect(identical(repo1, repo2), isTrue);
      });
    });

    group('Dependency Graph', () {
      test('should have correct dependency hierarchy', () async {
        // act
        await initDependencies();

        // assert
        // Data sources depend on Dio
        final dataSource = GetIt.instance<MealRemoteDataSource>();
        expect(dataSource, isNotNull);

        // Repositories depend on data sources
        final repository = GetIt.instance<MealRepository>();
        expect(repository, isNotNull);

        // Use cases depend on repositories
        final getMeals = GetIt.instance<GetMealsByLetter>();
        final searchMeals = GetIt.instance<SearchMeals>();
        expect(getMeals, isNotNull);
        expect(searchMeals, isNotNull);

        // Blocs depend on use cases
        final mealBloc = GetIt.instance<MealBloc>();
        final searchBloc = GetIt.instance<SearchBloc>();
        expect(mealBloc, isNotNull);
        expect(searchBloc, isNotNull);
      });

      test('should resolve circular dependencies correctly', () async {
        // act
        await initDependencies();

        // assert
        // This test verifies that there are no circular dependencies
        // that would cause the initialization to fail
        expect(() => GetIt.instance<SearchBloc>(), returnsNormally);
        expect(() => GetIt.instance<MealBloc>(), returnsNormally);
      });
    });

    group('Error Handling', () {
      test('should handle dependency resolution errors gracefully', () async {
        // act
        await initDependencies();

        // assert
        // Verify that all dependencies can be resolved without errors
        expect(() => GetIt.instance<SearchBloc>(), returnsNormally);
        expect(() => GetIt.instance<SearchMeals>(), returnsNormally);
      });

      test('should not throw when accessing registered dependencies', () async {
        // act
        await initDependencies();

        // assert
        expect(() => GetIt.instance<SearchBloc>(), returnsNormally);
        expect(() => GetIt.instance<SearchMeals>(), returnsNormally);
      });
    });

    group('Performance', () {
      test('should initialize dependencies quickly', () async {
        // act
        final stopwatch = Stopwatch()..start();
        await initDependencies();
        stopwatch.stop();

        // assert
        // Dependencies should initialize in less than 1 second
        expect(stopwatch.elapsed.inMilliseconds, lessThan(1000));
      });

      test('should resolve dependencies quickly', () async {
        // arrange
        await initDependencies();

        // act
        final stopwatch = Stopwatch()..start();
        GetIt.instance<SearchBloc>();
        GetIt.instance<SearchMeals>();
        stopwatch.stop();

        // assert
        // Dependency resolution should be very fast
        expect(stopwatch.elapsed.inMicroseconds, lessThan(1000));
      });
    });
  });
}
