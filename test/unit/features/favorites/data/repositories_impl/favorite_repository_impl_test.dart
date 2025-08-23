import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/data/datasources/favorite_local_datasource.dart';
import 'package:recipe_book/features/favorites/data/models/favorite_meal_model.dart';
import 'package:recipe_book/features/favorites/data/repositories_impl/favorite_repository_impl.dart';
import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';

import 'favorite_repository_impl_test.mocks.dart';

@GenerateMocks([FavoriteLocalDataSource])
void main() {
  group('FavoriteRepositoryImpl', () {
    late FavoriteRepositoryImpl repository;
    late MockFavoriteLocalDataSource mockLocalDataSource;

    setUp(() {
      mockLocalDataSource = MockFavoriteLocalDataSource();
      repository = FavoriteRepositoryImpl(mockLocalDataSource);
    });

    group('toggleFavorite', () {
      test('should call local data source toggleFavorite with correct mealId', () async {
        // Arrange
        const mealId = 'test-meal-id';
        when(mockLocalDataSource.toggleFavorite(mealId)).thenAnswer((_) async {});

        // Act
        await repository.toggleFavorite(mealId);

        // Assert
        verify(mockLocalDataSource.toggleFavorite(mealId)).called(1);
      });

      test('should propagate errors from local data source', () async {
        // Arrange
        const mealId = 'test-meal-id';
        when(mockLocalDataSource.toggleFavorite(mealId)).thenThrow(Exception('Data source error'));

        // Act & Assert
        expect(
          () => repository.toggleFavorite(mealId),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getFavoriteMeals', () {
      test('should return list of favorite meal entities', () async {
        // Arrange
        final testDateTime = DateTime(2024);
        final favoriteMealModels = [
          FavoriteMealModel(
            id: 'meal-1',
            name: 'Test Meal 1',
            thumbnail: 'https://example.com/meal1.jpg',
            category: 'Category 1',
            instructions: 'Instructions 1',
            ingredients: const {'ingredient1': 'amount1'},
            addedAt: testDateTime,
          ),
          FavoriteMealModel(
            id: 'meal-2',
            name: 'Test Meal 2',
            thumbnail: null,
            category: 'Category 2',
            instructions: 'Instructions 2',
            ingredients: const {'ingredient2': 'amount2'},
            addedAt: testDateTime,
          ),
        ];

        when(mockLocalDataSource.getFavoriteMeals()).thenAnswer((_) async => favoriteMealModels);

        // Act
        final result = await repository.getFavoriteMeals();

        // Assert
        expect(result, isA<List<FavoriteMeal>>());
        expect(result.length, equals(2));
        expect(result[0].id, equals('meal-1'));
        expect(result[1].id, equals('meal-2'));
        verify(mockLocalDataSource.getFavoriteMeals()).called(1);
      });

      test('should return empty list when no favorite meals exist', () async {
        // Arrange
        when(mockLocalDataSource.getFavoriteMeals()).thenAnswer((_) async => <FavoriteMealModel>[]);

        // Act
        final result = await repository.getFavoriteMeals();

        // Assert
        expect(result, isEmpty);
        verify(mockLocalDataSource.getFavoriteMeals()).called(1);
      });

      test('should propagate errors from local data source', () async {
        // Arrange
        when(mockLocalDataSource.getFavoriteMeals()).thenThrow(Exception('Data source error'));

        // Act & Assert
        expect(
          () => repository.getFavoriteMeals(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('isFavorite', () {
      test('should return true when meal is favorite', () async {
        // Arrange
        const mealId = 'favorite-meal-id';
        when(mockLocalDataSource.isFavorite(mealId)).thenAnswer((_) async => true);

        // Act
        final result = await repository.isFavorite(mealId);

        // Assert
        expect(result, isTrue);
        verify(mockLocalDataSource.isFavorite(mealId)).called(1);
      });

      test('should return false when meal is not favorite', () async {
        // Arrange
        const mealId = 'non-favorite-meal-id';
        when(mockLocalDataSource.isFavorite(mealId)).thenAnswer((_) async => false);

        // Act
        final result = await repository.isFavorite(mealId);

        // Assert
        expect(result, isFalse);
        verify(mockLocalDataSource.isFavorite(mealId)).called(1);
      });

      test('should propagate errors from local data source', () async {
        // Arrange
        const mealId = 'error-meal-id';
        when(mockLocalDataSource.isFavorite(mealId)).thenThrow(Exception('Data source error'));

        // Act & Assert
        expect(
          () => repository.isFavorite(mealId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
