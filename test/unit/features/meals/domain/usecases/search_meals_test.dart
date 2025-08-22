import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/search_meals.dart';

import 'search_meals_test.mocks.dart';

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

@GenerateMocks([MealRepository])
void main() {
  group('SearchMeals', () {
    late SearchMeals usecase;
    late MockMealRepository mockRepository;

    setUp(() {
      mockRepository = MockMealRepository();
      usecase = SearchMeals(mockRepository);
    });

    test('should search meals from repository', () async {
      // arrange
      const query = 'chicken';
      final expectedMeals = [
        buildTestMeal(id: '1', name: 'Chicken Pasta'),
        buildTestMeal(id: '2', name: 'Chicken Salad'),
      ];

      when(mockRepository.searchMeals(query)).thenAnswer((_) async => expectedMeals);

      // act
      final result = await usecase(query);

      // assert
      expect(result, expectedMeals);
      verify(mockRepository.searchMeals(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when repository returns empty', () async {
      // arrange
      const query = 'nonexistent';
      when(mockRepository.searchMeals(query)).thenAnswer((_) async => []);

      // act
      final result = await usecase(query);

      // assert
      expect(result, isEmpty);
      verify(mockRepository.searchMeals(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle repository errors', () async {
      // arrange
      const query = 'chicken';
      when(mockRepository.searchMeals(query)).thenThrow(Exception('Repository error'));

      // act & assert
      expect(
        () => usecase(query),
        throwsA(isA<Exception>()),
      );
      verify(mockRepository.searchMeals(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should search with different queries', () async {
      // arrange
      const query1 = 'chicken';
      const query2 = 'pasta';
      final expectedMeals1 = [buildTestMeal(id: '1', name: 'Chicken Pasta')];
      final expectedMeals2 = [buildTestMeal(id: '2', name: 'Pasta Carbonara')];

      when(mockRepository.searchMeals(query1)).thenAnswer((_) async => expectedMeals1);
      when(mockRepository.searchMeals(query2)).thenAnswer((_) async => expectedMeals2);

      // act
      final result1 = await usecase(query1);
      final result2 = await usecase(query2);

      // assert
      expect(result1, expectedMeals1);
      expect(result2, expectedMeals2);
      verify(mockRepository.searchMeals(query1));
      verify(mockRepository.searchMeals(query2));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should search with special characters in query', () async {
      // arrange
      const query = 'chicken & pasta';
      final expectedMeals = [buildTestMeal(id: '1', name: 'Chicken & Pasta')];

      when(mockRepository.searchMeals(query)).thenAnswer((_) async => expectedMeals);

      // act
      final result = await usecase(query);

      // assert
      expect(result, expectedMeals);
      verify(mockRepository.searchMeals(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should search with numbers in query', () async {
      // arrange
      const query = 'chicken123';
      final expectedMeals = [buildTestMeal(id: '1', name: 'Chicken123')];

      when(mockRepository.searchMeals(query)).thenAnswer((_) async => expectedMeals);

      // act
      final result = await usecase(query);

      // assert
      expect(result, expectedMeals);
      verify(mockRepository.searchMeals(query));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should search with empty query', () async {
      // arrange
      const query = '';
      when(mockRepository.searchMeals(query)).thenAnswer((_) async => []);

      // act
      final result = await usecase(query);

      // assert
      expect(result, isEmpty);
      verify(mockRepository.searchMeals(query));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
