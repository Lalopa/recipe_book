import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:recipe_book/features/favorites/domain/usecases/toggle_favorite.dart';

import 'toggle_favorite_test.mocks.dart';

@GenerateMocks([FavoriteRepository])
void main() {
  group('ToggleFavorite', () {
    late ToggleFavorite useCase;
    late MockFavoriteRepository mockRepository;

    setUp(() {
      mockRepository = MockFavoriteRepository();
      useCase = ToggleFavorite(mockRepository);
    });

    test('should call repository.toggleFavorite with correct mealId', () async {
      // Arrange
      const mealId = 'test-meal-id';
      when(mockRepository.toggleFavorite(mealId)).thenAnswer((_) async {});

      // Act
      await useCase(mealId);

      // Assert
      verify(mockRepository.toggleFavorite(mealId)).called(1);
    });

    test('should handle repository errors gracefully', () async {
      // Arrange
      const mealId = 'test-meal-id';
      when(mockRepository.toggleFavorite(mealId))
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase(mealId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle empty mealId', () async {
      // Arrange
      const mealId = '';
      when(mockRepository.toggleFavorite(mealId)).thenAnswer((_) async {});

      // Act
      await useCase(mealId);

      // Assert
      verify(mockRepository.toggleFavorite(mealId)).called(1);
    });

    test('should handle long mealId', () async {
      // Arrange
      const mealId = 'very-long-meal-id-with-many-characters-123456789';
      when(mockRepository.toggleFavorite(mealId)).thenAnswer((_) async {});

      // Act
      await useCase(mealId);

      // Assert
      verify(mockRepository.toggleFavorite(mealId)).called(1);
    });
  });
}
