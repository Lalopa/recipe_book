import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/features/favorites/data/datasources/favorite_local_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

import 'favorite_local_datasource_test.mocks.dart';

@GenerateMocks([ObjectBoxCacheManager])
void main() {
  group('FavoriteLocalDataSourceImpl', () {
    late MockObjectBoxCacheManager mockCacheManager;
    late FavoriteLocalDataSourceImpl dataSource;

    setUp(() {
      mockCacheManager = MockObjectBoxCacheManager();
      dataSource = FavoriteLocalDataSourceImpl(mockCacheManager);
    });

    group('toggleFavorite', () {
      const testMealId = 'test-meal-id';

      test(
        'should call cache manager toggleFavorite with correct mealId',
        () async {
          // arrange
          when(
            mockCacheManager.toggleFavorite(testMealId),
          ).thenAnswer((_) async {});

          // act
          await dataSource.toggleFavorite(testMealId);

          // assert
          verify(mockCacheManager.toggleFavorite(testMealId)).called(1);
        },
      );
    });

    group('isFavorite', () {
      const testMealId = 'test-meal-id';

      test('should return true when meal is favorite', () async {
        // arrange
        when(
          mockCacheManager.isFavorite(testMealId),
        ).thenAnswer((_) async => true);

        // act
        final result = await dataSource.isFavorite(testMealId);

        // assert
        expect(result, isTrue);
        verify(mockCacheManager.isFavorite(testMealId)).called(1);
      });

      test('should return false when meal is not favorite', () async {
        // arrange
        when(
          mockCacheManager.isFavorite(testMealId),
        ).thenAnswer((_) async => false);

        // act
        final result = await dataSource.isFavorite(testMealId);

        // assert
        expect(result, isFalse);
        verify(mockCacheManager.isFavorite(testMealId)).called(1);
      });
    });

    group('getFavoriteMeals', () {
      test('should return list of favorite meals from cache manager', () async {
        // arrange
        final testMeals = [
          const MealModel(
            id: 'meal1',
            name: 'Test Meal 1',
            thumbnail: 'thumbnail1.jpg',
            category: 'Test Category',
            instructions: 'Test Instructions 1',
            ingredients: {'ingredient1': 'amount1'},
          ),
          const MealModel(
            id: 'meal2',
            name: 'Test Meal 2',
            thumbnail: 'thumbnail2.jpg',
            category: 'Test Category',
            instructions: 'Test Instructions 2',
            ingredients: {'ingredient2': 'amount2'},
          ),
        ];

        when(
          mockCacheManager.getFavoriteMeals(),
        ).thenAnswer((_) async => testMeals);

        // act
        final result = await dataSource.getFavoriteMeals();

        // assert
        expect(result, equals(testMeals));
        verify(mockCacheManager.getFavoriteMeals()).called(1);
      });

      test('should return empty list when no favorite meals exist', () async {
        // arrange
        when(
          mockCacheManager.getFavoriteMeals(),
        ).thenAnswer((_) async => <MealModel>[]);

        // act
        final result = await dataSource.getFavoriteMeals();

        // assert
        expect(result, isEmpty);
        verify(mockCacheManager.getFavoriteMeals()).called(1);
      });
    });
  });
}
