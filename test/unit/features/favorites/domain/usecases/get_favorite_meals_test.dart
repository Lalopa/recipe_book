import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:recipe_book/features/favorites/domain/usecases/get_favorite_meals.dart';

import 'get_favorite_meals_test.mocks.dart';

@GenerateMocks([FavoriteRepository])
void main() {
  group('GetFavoriteMeals', () {
    late GetFavoriteMeals useCase;
    late MockFavoriteRepository mockRepository;

    setUp(() {
      mockRepository = MockFavoriteRepository();
      useCase = GetFavoriteMeals(mockRepository);
    });

    test('should return list of favorite meals when repository has favorites', () async {
      // Arrange
      final favoriteMeals = [
        const FavoriteMeal(
          id: 'meal-1',
          name: 'Favorite Meal 1',
          thumbnail: 'https://example.com/meal1.jpg',
          category: 'Category 1',
          instructions: 'Instructions for meal 1',
          ingredients: {'ingredient1': 'amount1'},
          addedAt: null,
        ),
        const FavoriteMeal(
          id: 'meal-2',
          name: 'Favorite Meal 2',
          thumbnail: 'https://example.com/meal2.jpg',
          category: 'Category 2',
          instructions: 'Instructions for meal 2',
          ingredients: {'ingredient2': 'amount2'},
          addedAt: null,
        ),
      ];

      when(mockRepository.getFavoriteMeals()).thenAnswer((_) async => favoriteMeals);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(favoriteMeals));
      expect(result.length, equals(2));
      verify(mockRepository.getFavoriteMeals()).called(1);
    });

    test('should return empty list when repository has no favorites', () async {
      // Arrange
      when(mockRepository.getFavoriteMeals()).thenAnswer((_) async => <FavoriteMeal>[]);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      expect(result.length, equals(0));
      verify(mockRepository.getFavoriteMeals()).called(1);
    });

    test('should handle repository errors gracefully', () async {
      // Arrange
      when(mockRepository.getFavoriteMeals())
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
    });

    test('should return single favorite meal when repository has only one', () async {
      // Arrange
      final singleFavoriteMeal = [
        const FavoriteMeal(
          id: 'single-meal',
          name: 'Single Favorite Meal',
          thumbnail: 'https://example.com/single.jpg',
          category: 'Single Category',
          instructions: 'Single meal instructions',
          ingredients: {'single': 'ingredient'},
          addedAt: null,
        ),
      ];

      when(mockRepository.getFavoriteMeals()).thenAnswer((_) async => singleFavoriteMeal);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(singleFavoriteMeal));
      expect(result.length, equals(1));
      verify(mockRepository.getFavoriteMeals()).called(1);
    });

    test('should handle large number of favorites efficiently', () async {
      // Arrange
      final manyFavorites = List.generate(
        100,
        (index) => FavoriteMeal(
          id: 'meal-$index',
          name: 'Favorite Meal $index',
          thumbnail: 'https://example.com/meal$index.jpg',
          category: 'Category $index',
          instructions: 'Instructions for meal $index',
          ingredients: {'ingredient$index': 'amount$index'},
          addedAt: null,
        ),
      );

      when(mockRepository.getFavoriteMeals()).thenAnswer((_) async => manyFavorites);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(manyFavorites));
      expect(result.length, equals(100));
      verify(mockRepository.getFavoriteMeals()).called(1);
    });
  });
}
