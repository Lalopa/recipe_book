import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/favorites/data/models/favorite_meal_model.dart';
import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

void main() {
  group('FavoriteMealModel', () {
    test('should create FavoriteMealModel from factory constructor', () {
      // Arrange
      const id = 'test_id';
      const name = 'Test Meal';
      const thumbnail = 'test_thumbnail.jpg';
      const category = 'Test Category';
      const instructions = 'Test instructions';
      const ingredients = <String, String>{'ingredient1': 'measure1'};
      final addedAt = DateTime.now();

      // Act
      final model = FavoriteMealModel(
        id: id,
        name: name,
        thumbnail: thumbnail,
        category: category,
        instructions: instructions,
        ingredients: ingredients,
        addedAt: addedAt,
      );

      // Assert
      expect(model.id, equals(id));
      expect(model.name, equals(name));
      expect(model.thumbnail, equals(thumbnail));
      expect(model.category, equals(category));
      expect(model.instructions, equals(instructions));
      expect(model.ingredients, equals(ingredients));
      expect(model.addedAt, equals(addedAt));
    });

    test('should create FavoriteMealModel from MealModel', () {
      // Arrange
      const mealModel = MealModel(
        id: 'test_id',
        name: 'Test Meal',
        thumbnail: 'test_thumbnail.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
      );

      // Act
      final favoriteModel = FavoriteMealModel.fromMealModel(mealModel);

      // Assert
      expect(favoriteModel.id, equals(mealModel.id));
      expect(favoriteModel.name, equals(mealModel.name));
      expect(favoriteModel.thumbnail, equals(mealModel.thumbnail));
      expect(favoriteModel.category, equals(mealModel.category));
      expect(favoriteModel.instructions, equals(mealModel.instructions));
      expect(favoriteModel.ingredients, equals(mealModel.ingredients));
      expect(favoriteModel.addedAt, isNotNull);
    });

    test('should convert to entity correctly', () {
      // Arrange
      final addedAt = DateTime.now();
      final model = FavoriteMealModel(
        id: 'test_id',
        name: 'Test Meal',
        thumbnail: 'test_thumbnail.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        addedAt: addedAt,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity, isA<FavoriteMeal>());
      expect(entity.id, equals(model.id));
      expect(entity.name, equals(model.name));
      expect(entity.thumbnail, equals(model.thumbnail));
      expect(entity.category, equals(model.category));
      expect(entity.instructions, equals(model.instructions));
      expect(entity.ingredients, equals(model.ingredients));
      expect(entity.addedAt, equals(model.addedAt));
    });

    test('should support copyWith', () {
      // Arrange
      const originalModel = FavoriteMealModel(
        id: 'test_id',
        name: 'Test Meal',
        thumbnail: 'test_thumbnail.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        addedAt: null,
      );

      // Act
      final updatedModel = originalModel.copyWith(
        name: 'Updated Meal',
        category: 'Updated Category',
      );

      // Assert
      expect(updatedModel.id, equals(originalModel.id));
      expect(updatedModel.name, equals('Updated Meal'));
      expect(updatedModel.category, equals('Updated Category'));
      expect(updatedModel.thumbnail, equals(originalModel.thumbnail));
      expect(updatedModel.instructions, equals(originalModel.instructions));
      expect(updatedModel.ingredients, equals(originalModel.ingredients));
      expect(updatedModel.addedAt, equals(originalModel.addedAt));
    });

    test('should support equality', () {
      // Arrange
      const model1 = FavoriteMealModel(
        id: 'test_id',
        name: 'Test Meal',
        thumbnail: 'test_thumbnail.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        addedAt: null,
      );

      const model2 = FavoriteMealModel(
        id: 'test_id',
        name: 'Test Meal',
        thumbnail: 'test_thumbnail.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        addedAt: null,
      );

      // Act & Assert
      expect(model1, equals(model2));
      expect(model1.hashCode, equals(model2.hashCode));
    });
  });
}
