import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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

@GenerateMocks([MealRemoteDataSource])
void main() {
  group('MealRepositoryImpl', () {
    late MealRepositoryImpl repository;
    late MockMealRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockMealRemoteDataSource();
      repository = MealRepositoryImpl(mockRemoteDataSource);
    });

    group('getMealsByLetter', () {
      test('should return meals when remote data source succeeds', () async {
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

        when(mockRemoteDataSource.fetchByLetter(letter)).thenAnswer((_) async => mealModels);

        // act
        final result = await repository.getMealsByLetter(letter);

        // assert
        expect(result, expectedMeals);
        verify(mockRemoteDataSource.fetchByLetter(letter));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return empty list when remote data source returns empty', () async {
        // arrange
        const letter = 'x';
        when(mockRemoteDataSource.fetchByLetter(letter)).thenAnswer((_) async => []);

        // act
        final result = await repository.getMealsByLetter(letter);

        // assert
        expect(result, isEmpty);
        verify(mockRemoteDataSource.fetchByLetter(letter));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should propagate errors from remote data source', () async {
        // arrange
        const letter = 'a';
        when(mockRemoteDataSource.fetchByLetter(letter)).thenThrow(Exception('Network error'));

        // act & assert
        expect(
          () => repository.getMealsByLetter(letter),
          throwsA(isA<Exception>()),
        );
        verify(mockRemoteDataSource.fetchByLetter(letter));
        verifyNoMoreInteractions(mockRemoteDataSource);
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
        when(mockRemoteDataSource.searchMeals(query)).thenThrow(Exception('Network error'));

        // act & assert
        expect(
          () => repository.searchMeals(query),
          throwsA(isA<Exception>()),
        );
        verify(mockRemoteDataSource.searchMeals(query));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should search with different queries', () async {
        // arrange
        const query1 = 'chicken';
        const query2 = 'pasta';
        final mealModels1 = [buildTestMealModel(id: '1', name: 'Chicken Pasta')];
        final mealModels2 = [buildTestMealModel(id: '2', name: 'Pasta Carbonara')];
        final expectedMeals1 = [buildTestMeal(id: '1', name: 'Chicken Pasta')];
        final expectedMeals2 = [buildTestMeal(id: '2', name: 'Pasta Carbonara')];

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
