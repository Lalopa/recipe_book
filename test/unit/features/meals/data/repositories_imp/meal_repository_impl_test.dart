import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_local_datasource.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

import 'meal_repository_impl_test.mocks.dart';

// Helper para crear MealModel de prueba
MealModel buildTestMealModel({
  required String id,
  required String name,
  String? thumbnail,
  String? category,
  String? instructions,
  Map<String, String>? ingredients,
}) {
  return MealModel(
    id: id,
    name: name,
    thumbnail: thumbnail ?? 'https://example.com/$id.jpg',
    category: category ?? 'Category $id',
    instructions: instructions ?? 'Instructions for $name',
    ingredients: ingredients ?? {'ingredient1': 'amount1'},
  );
}

// Helper para crear Meal de prueba
Meal buildTestMeal({
  required String id,
  required String name,
  String? thumbnail,
  String? category,
  String? instructions,
  Map<String, String>? ingredients,
}) {
  return Meal(
    id: id,
    name: name,
    thumbnail: thumbnail ?? 'https://example.com/$id.jpg',
    category: category ?? 'Category $id',
    instructions: instructions ?? 'Instructions for $name',
    ingredients: ingredients ?? {'ingredient1': 'amount1'},
  );
}

@GenerateMocks([MealRemoteDataSource, MealLocalDataSource])
void main() {
  group('MealRepositoryImpl', () {
    late MealRepositoryImpl repository;
    late MockMealRemoteDataSource mockRemoteDataSource;
    late MockMealLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockMealRemoteDataSource();
      mockLocalDataSource = MockMealLocalDataSource();
      repository = MealRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
    });

    group('getMealsByLetter', () {
      test('should return cached meals when available', () async {
        // arrange
        const letter = 'a';
        final cachedMealModels = [
          buildTestMealModel(id: '1', name: 'Apple Pie'),
          buildTestMealModel(id: '2', name: 'Avocado Salad'),
        ];
        final expectedMeals = [
          buildTestMeal(id: '1', name: 'Apple Pie'),
          buildTestMeal(id: '2', name: 'Avocado Salad'),
        ];

        when(mockLocalDataSource.getCachedMealsByLetter(letter)).thenAnswer((_) async => cachedMealModels);

        // act
        final result = await repository.getMealsByLetter(letter);

        // assert
        expect(result, expectedMeals);
        verify(mockLocalDataSource.getCachedMealsByLetter(letter));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return meals from remote when no cache available', () async {
        // arrange
        const letter = 'a';
        final mealModels = [
          buildTestMealModel(id: '1', name: 'Apple Pie'),
          buildTestMealModel(id: '2', name: 'Avocado Salad'),
        ];
        final expectedMeals = [
          buildTestMeal(id: '1', name: 'Apple Pie'),
          buildTestMeal(id: '2', name: 'Avocado Salad'),
        ];

        when(mockLocalDataSource.getCachedMealsByLetter(letter)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.fetchByLetter(letter)).thenAnswer((_) async => mealModels);
        when(mockLocalDataSource.cacheMealsByLetter(letter, mealModels)).thenAnswer((_) async {});

        // act
        final result = await repository.getMealsByLetter(letter);

        // assert
        expect(result, expectedMeals);
        verify(mockLocalDataSource.getCachedMealsByLetter(letter));
        verify(mockRemoteDataSource.fetchByLetter(letter));
        verify(mockLocalDataSource.cacheMealsByLetter(letter, mealModels));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return meals from remote when cache is empty', () async {
        // arrange
        const letter = 'a';
        final mealModels = [
          buildTestMealModel(id: '1', name: 'Apple Pie'),
          buildTestMealModel(id: '2', name: 'Avocado Salad'),
        ];
        final expectedMeals = [
          buildTestMeal(id: '1', name: 'Apple Pie'),
          buildTestMeal(id: '2', name: 'Avocado Salad'),
        ];

        when(mockLocalDataSource.getCachedMealsByLetter(letter)).thenAnswer((_) async => []);
        when(mockRemoteDataSource.fetchByLetter(letter)).thenAnswer((_) async => mealModels);
        when(mockLocalDataSource.cacheMealsByLetter(letter, mealModels)).thenAnswer((_) async {});

        // act
        final result = await repository.getMealsByLetter(letter);

        // assert
        expect(result, expectedMeals);
        verify(mockLocalDataSource.getCachedMealsByLetter(letter));
        verify(mockRemoteDataSource.fetchByLetter(letter));
        verify(mockLocalDataSource.cacheMealsByLetter(letter, mealModels));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should return empty list when no cache and remote returns empty', () async {
        // arrange
        const letter = 'x';
        when(mockLocalDataSource.getCachedMealsByLetter(letter)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.fetchByLetter(letter)).thenAnswer((_) async => []);

        // act
        final result = await repository.getMealsByLetter(letter);

        // assert
        expect(result, isEmpty);
        verify(mockLocalDataSource.getCachedMealsByLetter(letter));
        verify(mockRemoteDataSource.fetchByLetter(letter));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should propagate errors from remote data source when no cache', () async {
        // arrange
        const letter = 'a';
        when(mockLocalDataSource.getCachedMealsByLetter(letter)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.fetchByLetter(letter)).thenThrow(Exception('Network error'));

        // act & assert
        try {
          await repository.getMealsByLetter(letter);
          fail('Expected exception was not thrown');
        } on Exception catch (e) {
          expect(e, isA<Exception>());
        }

        verify(mockLocalDataSource.getCachedMealsByLetter(letter));
        verify(mockRemoteDataSource.fetchByLetter(letter));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should propagate errors from local data source', () async {
        // arrange
        const letter = 'a';
        when(mockLocalDataSource.getCachedMealsByLetter(letter)).thenThrow(Exception('Cache error'));

        // act & assert
        expect(
          () => repository.getMealsByLetter(letter),
          throwsA(isA<Exception>()),
        );
        verify(mockLocalDataSource.getCachedMealsByLetter(letter));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });

    group('searchMeals', () {
      test('should return meals when remote data source succeeds', () async {
        // arrange
        const query = 'chicken';
        final mealModels = [
          buildTestMealModel(id: '1', name: 'Chicken Pasta'),
          buildTestMealModel(id: '2', name: 'Chicken Salad'),
        ];
        final expectedMeals = [
          buildTestMeal(id: '1', name: 'Chicken Pasta'),
          buildTestMeal(id: '2', name: 'Chicken Salad'),
        ];

        when(mockLocalDataSource.getCachedSearchResults(query)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.searchMeals(query)).thenAnswer((_) async => mealModels);

        // act
        final result = await repository.searchMeals(query);

        // assert
        expect(result, expectedMeals);
        verify(mockRemoteDataSource.searchMeals(query));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return empty list when remote data source returns empty', () async {
        // arrange
        const query = 'nonexistent';
        when(mockLocalDataSource.getCachedSearchResults(query)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.searchMeals(query)).thenAnswer((_) async => []);

        // act
        final result = await repository.searchMeals(query);

        // assert
        expect(result, isEmpty);
        verify(mockRemoteDataSource.searchMeals(query));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should propagate errors from remote data source', () async {
        // arrange
        const query = 'chicken';
        when(mockLocalDataSource.getCachedSearchResults(query)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.searchMeals(query)).thenThrow(Exception('Network error'));

        // act & assert
        try {
          await repository.searchMeals(query);
          fail('Expected exception was not thrown');
        } on Exception catch (e) {
          expect(e, isA<Exception>());
        }

        verify(mockLocalDataSource.getCachedSearchResults(query));
        verify(mockRemoteDataSource.searchMeals(query));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('should search with different queries', () async {
        // arrange
        const query1 = 'chicken';
        const query2 = 'pasta';
        final mealModels1 = [buildTestMealModel(id: '1', name: 'Chicken Pasta')];
        final mealModels2 = [buildTestMealModel(id: '2', name: 'Pasta Carbonara')];
        final expectedMeals1 = [buildTestMeal(id: '1', name: 'Chicken Pasta')];
        final expectedMeals2 = [buildTestMeal(id: '2', name: 'Pasta Carbonara')];

        when(mockLocalDataSource.getCachedSearchResults(query1)).thenAnswer((_) async => null);
        when(mockLocalDataSource.getCachedSearchResults(query2)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.searchMeals(query1)).thenAnswer((_) async => mealModels1);
        when(mockRemoteDataSource.searchMeals(query2)).thenAnswer((_) async => mealModels2);

        // act
        final result1 = await repository.searchMeals(query1);
        final result2 = await repository.searchMeals(query2);

        // assert
        expect(result1, expectedMeals1);
        expect(result2, expectedMeals2);
        verify(mockRemoteDataSource.searchMeals(query1));
        verify(mockRemoteDataSource.searchMeals(query2));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should search with special characters in query', () async {
        // arrange
        const query = 'chicken & pasta';
        final mealModels = [buildTestMealModel(id: '1', name: 'Chicken & Pasta')];
        final expectedMeals = [buildTestMeal(id: '1', name: 'Chicken & Pasta')];

        when(mockLocalDataSource.getCachedSearchResults(query)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.searchMeals(query)).thenAnswer((_) async => mealModels);

        // act
        final result = await repository.searchMeals(query);

        // assert
        expect(result, expectedMeals);
        verify(mockRemoteDataSource.searchMeals(query));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should search with numbers in query', () async {
        // arrange
        const query = 'chicken123';
        final mealModels = [buildTestMealModel(id: '1', name: 'Chicken123')];
        final expectedMeals = [buildTestMeal(id: '1', name: 'Chicken123')];

        when(mockLocalDataSource.getCachedSearchResults(query)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.searchMeals(query)).thenAnswer((_) async => mealModels);

        // act
        final result = await repository.searchMeals(query);

        // assert
        expect(result, expectedMeals);
        verify(mockRemoteDataSource.searchMeals(query));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should search with empty query', () async {
        // arrange
        const query = '';
        when(mockLocalDataSource.getCachedSearchResults(query)).thenAnswer((_) async => null);
        when(mockRemoteDataSource.searchMeals(query)).thenAnswer((_) async => []);

        // act
        final result = await repository.searchMeals(query);

        // assert
        expect(result, isEmpty);
        verify(mockRemoteDataSource.searchMeals(query));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });
  });
}
