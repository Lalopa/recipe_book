import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:recipe_book/features/favorites/domain/usecases/check_favorite_status.dart';

import 'check_favorite_status_test.mocks.dart';

@GenerateMocks([FavoriteRepository])
void main() {
  group('CheckFavoriteStatus', () {
    late CheckFavoriteStatus useCase;
    late MockFavoriteRepository mockRepository;

    setUp(() {
      mockRepository = MockFavoriteRepository();
      useCase = CheckFavoriteStatus(mockRepository);
    });

    test('should return true when meal is favorite', () async {
      // Arrange
      const mealId = 'favorite-meal-id';
      when(mockRepository.isFavorite(mealId)).thenAnswer((_) async => true);

      // Act
      final result = await useCase(mealId);

      // Assert
      expect(result, isTrue);
      verify(mockRepository.isFavorite(mealId)).called(1);
    });

    test('should return false when meal is not favorite', () async {
      // Arrange
      const mealId = 'non-favorite-meal-id';
      when(mockRepository.isFavorite(mealId)).thenAnswer((_) async => false);

      // Act
      final result = await useCase(mealId);

      // Assert
      expect(result, isFalse);
      verify(mockRepository.isFavorite(mealId)).called(1);
    });

    test('should handle repository errors gracefully', () async {
      // Arrange
      const mealId = 'test-meal-id';
      when(mockRepository.isFavorite(mealId)).thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase(mealId),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle empty mealId', () async {
      // Arrange
      const mealId = '';
      when(mockRepository.isFavorite(mealId)).thenAnswer((_) async => false);

      // Act
      final result = await useCase(mealId);

      // Assert
      expect(result, isFalse);
      verify(mockRepository.isFavorite(mealId)).called(1);
    });

    test('should handle long mealId', () async {
      // Arrange
      const mealId = 'very-long-meal-id-with-many-characters-123456789';
      when(mockRepository.isFavorite(mealId)).thenAnswer((_) async => true);

      // Act
      final result = await useCase(mealId);

      // Assert
      expect(result, isTrue);
      verify(mockRepository.isFavorite(mealId)).called(1);
    });
  });
}
