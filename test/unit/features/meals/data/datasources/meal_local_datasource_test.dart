import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_local_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

import 'meal_local_datasource_test.mocks.dart';

@GenerateMocks([ObjectBoxCacheManager])
void main() {
  group('MealLocalDataSource', () {
    late MealLocalDataSourceImpl dataSource;
    late MockObjectBoxCacheManager mockCacheManager;

    setUp(() {
      mockCacheManager = MockObjectBoxCacheManager();
      dataSource = MealLocalDataSourceImpl(mockCacheManager);
    });

    group('getCachedMealsByLetter', () {
      test('should return cached meals when cache has data', () async {
        // arrange
        const letter = 'A';
        final expectedMeals = [
          const MealModel(
            id: '1',
            name: 'Apple Pie',
            thumbnail: 'https://example.com/apple.jpg',
            category: 'Dessert',
            instructions: 'Make apple pie',
            ingredients: {'apple': '2 cups', 'flour': '1 cup'},
          ),
          const MealModel(
            id: '2',
            name: 'Avocado Toast',
            thumbnail: 'https://example.com/avocado.jpg',
            category: 'Breakfast',
            instructions: 'Make avocado toast',
            ingredients: {'avocado': '1 piece', 'bread': '2 slices'},
          ),
        ];

        when(mockCacheManager.getCachedMeals(letter)).thenAnswer((_) async => expectedMeals);

        // act
        final result = await dataSource.getCachedMealsByLetter(letter);

        // assert
        expect(result, equals(expectedMeals));
        verify(mockCacheManager.getCachedMeals(letter)).called(1);
      });

      test('should return null when cache has no data', () async {
        // arrange
        const letter = 'Z';
        when(mockCacheManager.getCachedMeals(letter)).thenAnswer((_) async => null);

        // act
        final result = await dataSource.getCachedMealsByLetter(letter);

        // assert
        expect(result, isNull);
        verify(mockCacheManager.getCachedMeals(letter)).called(1);
      });

      test('should return empty list when cache returns empty list', () async {
        // arrange
        const letter = 'X';
        when(mockCacheManager.getCachedMeals(letter)).thenAnswer((_) async => <MealModel>[]);

        // act
        final result = await dataSource.getCachedMealsByLetter(letter);

        // assert
        expect(result, isEmpty);
        verify(mockCacheManager.getCachedMeals(letter)).called(1);
      });

      test('should handle single letter correctly', () async {
        // arrange
        const letter = 'B';
        final expectedMeals = [
          const MealModel(
            id: '3',
            name: 'Banana Bread',
            thumbnail: 'https://example.com/banana.jpg',
            category: 'Bread',
            instructions: 'Make banana bread',
            ingredients: {'banana': '3 pieces', 'flour': '2 cups'},
          ),
        ];

        when(mockCacheManager.getCachedMeals(letter)).thenAnswer((_) async => expectedMeals);

        // act
        final result = await dataSource.getCachedMealsByLetter(letter);

        // assert
        expect(result, equals(expectedMeals));
        verify(mockCacheManager.getCachedMeals(letter)).called(1);
      });
    });

    group('cacheMealsByLetter', () {
      test('should cache meals with 30 minutes TTL', () async {
        // arrange
        const letter = 'C';
        final meals = [
          const MealModel(
            id: '4',
            name: 'Chocolate Cake',
            thumbnail: 'https://example.com/chocolate.jpg',
            category: 'Dessert',
            instructions: 'Make chocolate cake',
            ingredients: {'chocolate': '200g', 'flour': '1.5 cups'},
          ),
        ];

        when(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).thenAnswer((_) async {});

        // act
        await dataSource.cacheMealsByLetter(letter, meals);

        // assert
        verify(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).called(1);
      });

      test('should cache empty meals list', () async {
        // arrange
        const letter = 'D';
        final meals = <MealModel>[];

        when(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).thenAnswer((_) async {});

        // act
        await dataSource.cacheMealsByLetter(letter, meals);

        // assert
        verify(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).called(1);
      });

      test('should cache single meal', () async {
        // arrange
        const letter = 'E';
        final meals = [
          const MealModel(
            id: '5',
            name: 'Eggs Benedict',
            thumbnail: 'https://example.com/eggs.jpg',
            category: 'Breakfast',
            instructions: 'Make eggs benedict',
            ingredients: {'eggs': '2 pieces', 'ham': '2 slices'},
          ),
        ];

        when(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).thenAnswer((_) async {});

        // act
        await dataSource.cacheMealsByLetter(letter, meals);

        // assert
        verify(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).called(1);
      });
    });

    group('getCachedSearchResults', () {
      test('should return cached search results for normalized query', () async {
        // arrange
        const query = '  Pizza  ';
        const normalizedQuery = 'pizza';
        final expectedMeals = [
          const MealModel(
            id: '6',
            name: 'Margherita Pizza',
            thumbnail: 'https://example.com/pizza.jpg',
            category: 'Italian',
            instructions: 'Make margherita pizza',
            ingredients: {'dough': '1 ball', 'tomato': '2 pieces', 'mozzarella': '200g'},
          ),
        ];

        when(mockCacheManager.getCachedMeals(normalizedQuery)).thenAnswer((_) async => expectedMeals);

        // act
        final result = await dataSource.getCachedSearchResults(query);

        // assert
        expect(result, equals(expectedMeals));
        verify(mockCacheManager.getCachedMeals(normalizedQuery)).called(1);
      });

      test('should return null when no search results cached', () async {
        // arrange
        const query = 'Sushi';
        const normalizedQuery = 'sushi';
        when(mockCacheManager.getCachedMeals(normalizedQuery)).thenAnswer((_) async => null);

        // act
        final result = await dataSource.getCachedSearchResults(query);

        // assert
        expect(result, isNull);
        verify(mockCacheManager.getCachedMeals(normalizedQuery)).called(1);
      });

      test('should handle empty search query', () async {
        // arrange
        const query = '';
        const normalizedQuery = '';
        when(mockCacheManager.getCachedMeals(normalizedQuery)).thenAnswer((_) async => <MealModel>[]);

        // act
        final result = await dataSource.getCachedSearchResults(query);

        // assert
        expect(result, isEmpty);
        verify(mockCacheManager.getCachedMeals(normalizedQuery)).called(1);
      });

      test('should handle query with only whitespace', () async {
        // arrange
        const query = '   ';
        const normalizedQuery = '';
        when(mockCacheManager.getCachedMeals(normalizedQuery)).thenAnswer((_) async => <MealModel>[]);

        // act
        final result = await dataSource.getCachedSearchResults(query);

        // assert
        expect(result, isEmpty);
        verify(mockCacheManager.getCachedMeals(normalizedQuery)).called(1);
      });

      test('should handle query with mixed case and spaces', () async {
        // arrange
        const query = '  ChIcKeN  CuRrY  ';
        const normalizedQuery = 'chicken  curry';
        final expectedMeals = [
          const MealModel(
            id: '7',
            name: 'Chicken Curry',
            thumbnail: 'https://example.com/curry.jpg',
            category: 'Indian',
            instructions: 'Make chicken curry',
            ingredients: {'chicken': '500g', 'curry powder': '2 tbsp'},
          ),
        ];

        when(mockCacheManager.getCachedMeals(normalizedQuery)).thenAnswer((_) async => expectedMeals);

        // act
        final result = await dataSource.getCachedSearchResults(query);

        // assert
        expect(result, equals(expectedMeals));
        verify(mockCacheManager.getCachedMeals(normalizedQuery)).called(1);
      });
    });

    group('cacheSearchResults', () {
      test('should cache search results with 1 hour TTL', () async {
        // arrange
        const query = 'Pasta';
        const normalizedQuery = 'pasta';
        final meals = [
          const MealModel(
            id: '8',
            name: 'Spaghetti Carbonara',
            thumbnail: 'https://example.com/pasta.jpg',
            category: 'Italian',
            instructions: 'Make spaghetti carbonara',
            ingredients: {'spaghetti': '400g', 'eggs': '4 pieces', 'pecorino': '100g'},
          ),
        ];

        when(
          mockCacheManager.cacheMeals(
            normalizedQuery,
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).thenAnswer((_) async {});

        // act
        await dataSource.cacheSearchResults(query, meals);

        // assert
        verify(
          mockCacheManager.cacheMeals(
            normalizedQuery,
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).called(1);
      });

      test('should cache empty search results', () async {
        // arrange
        const query = 'NonExistentDish';
        const normalizedQuery = 'nonexistentdish';
        final meals = <MealModel>[];

        when(
          mockCacheManager.cacheMeals(
            normalizedQuery,
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).thenAnswer((_) async {});

        // act
        await dataSource.cacheSearchResults(query, meals);

        // assert
        verify(
          mockCacheManager.cacheMeals(
            normalizedQuery,
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).called(1);
      });

      test('should handle query with special characters', () async {
        // arrange
        const query = 'Café au Lait';
        const normalizedQuery = 'café au lait';
        final meals = [
          const MealModel(
            id: '9',
            name: 'Café au Lait',
            thumbnail: 'https://example.com/coffee.jpg',
            category: 'Beverage',
            instructions: 'Make café au lait',
            ingredients: {'coffee': '1 cup', 'milk': '1 cup'},
          ),
        ];

        when(
          mockCacheManager.cacheMeals(
            normalizedQuery,
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).thenAnswer((_) async {});

        // act
        await dataSource.cacheSearchResults(query, meals);

        // assert
        verify(
          mockCacheManager.cacheMeals(
            normalizedQuery,
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).called(1);
      });
    });

    group('normalizeQuery', () {
      test('should trim whitespace and convert to lowercase', () {
        // arrange
        const query = '  HELLO  WORLD  ';
        const expected = 'hello  world';

        // act
        final result = dataSource.normalizeQuery(query);

        // assert
        expect(result, equals(expected));
      });

      test('should handle empty string', () {
        // arrange
        const query = '';
        const expected = '';

        // act
        final result = dataSource.normalizeQuery(query);

        // assert
        expect(result, equals(expected));
      });

      test('should handle string with only whitespace', () {
        // arrange
        const query = '   ';
        const expected = '';

        // act
        final result = dataSource.normalizeQuery(query);

        // assert
        expect(result, equals(expected));
      });

      test('should handle mixed case string', () {
        // arrange
        const query = 'HeLLo WoRLd';
        const expected = 'hello world';

        // act
        final result = dataSource.normalizeQuery(query);

        // assert
        expect(result, equals(expected));
      });

      test('should handle string with no whitespace', () {
        // arrange
        const query = 'HELLO';
        const expected = 'hello';

        // act
        final result = dataSource.normalizeQuery(query);

        // assert
        expect(result, equals(expected));
      });

      test('should handle string with multiple spaces', () {
        // arrange
        const query = '  hello   world  ';
        const expected = 'hello   world';

        // act
        final result = dataSource.normalizeQuery(query);

        // assert
        expect(result, equals(expected));
      });
    });

    group('error handling', () {
      test('should propagate errors from cache manager', () async {
        // arrange
        const letter = 'A';
        when(mockCacheManager.getCachedMeals(letter)).thenThrow(Exception('Cache error'));

        // act & assert
        expect(
          () => dataSource.getCachedMealsByLetter(letter),
          throwsA(isA<Exception>()),
        );
        verify(mockCacheManager.getCachedMeals(letter)).called(1);
      });

      test('should propagate errors when caching meals', () async {
        // arrange
        const letter = 'B';
        final meals = [
          const MealModel(
            id: '10',
            name: 'Test Meal',
            thumbnail: 'https://example.com/test.jpg',
            category: 'Test',
            instructions: 'Test instructions',
            ingredients: {'test': '1 unit'},
          ),
        ];

        when(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).thenThrow(Exception('Cache error'));

        // act & assert
        expect(
          () => dataSource.cacheMealsByLetter(letter, meals),
          throwsA(isA<Exception>()),
        );
        verify(
          mockCacheManager.cacheMeals(
            letter,
            meals,
            ttl: const Duration(minutes: 30),
          ),
        ).called(1);
      });

      test('should propagate errors when caching search results', () async {
        // arrange
        const query = 'Test';
        final meals = [
          const MealModel(
            id: '11',
            name: 'Test Meal',
            thumbnail: 'https://example.com/test.jpg',
            category: 'Test',
            instructions: 'Test instructions',
            ingredients: {'test': '1 unit'},
          ),
        ];

        when(
          mockCacheManager.cacheMeals(
            'test',
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).thenThrow(Exception('Cache error'));

        // act & assert
        expect(
          () => dataSource.cacheSearchResults(query, meals),
          throwsA(isA<Exception>()),
        );
        verify(
          mockCacheManager.cacheMeals(
            'test',
            meals,
            ttl: const Duration(hours: 1),
          ),
        ).called(1);
      });
    });
  });
}
