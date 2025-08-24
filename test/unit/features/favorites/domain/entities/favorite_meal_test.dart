import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

void main() {
  group('FavoriteMeal', () {
    const testId = 'test-id-123';
    const testName = 'Test Meal Name';
    const testThumbnail = 'https://example.com/test-image.jpg';
    const testCategory = 'Test Category';
    const testInstructions = 'Test instructions for the meal';
    const testIngredients = {'ingredient1': 'amount1', 'ingredient2': 'amount2'};

    group('Constructor', () {
      test('should create a FavoriteMeal with all required parameters', () {
        const favoriteMeal = Meal(
          id: testId,
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        expect(favoriteMeal.id, equals(testId));
        expect(favoriteMeal.name, equals(testName));
        expect(favoriteMeal.thumbnail, equals(testThumbnail));
        expect(favoriteMeal.category, equals(testCategory));
        expect(favoriteMeal.instructions, equals(testInstructions));
        expect(favoriteMeal.ingredients, equals(testIngredients));
      });

      test('should create a FavoriteMeal with null thumbnail', () {
        const favoriteMeal = Meal(
          id: testId,
          name: testName,
          thumbnail: null,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        expect(favoriteMeal.thumbnail, isNull);
      });
    });

    group('FavoriteMeal.empty', () {
      test('should create an empty FavoriteMeal with default values', () {
        const emptyMeal = Meal.empty();

        expect(emptyMeal.id, equals(''));
        expect(emptyMeal.name, equals(''));
        expect(emptyMeal.thumbnail, isNull);
        expect(emptyMeal.category, equals(''));
        expect(emptyMeal.instructions, equals(''));
        expect(emptyMeal.ingredients, equals(const {}));
      });
    });

    group('copyWith', () {
      const originalMeal = Meal(
        id: testId,
        name: testName,
        thumbnail: testThumbnail,
        category: testCategory,
        instructions: testInstructions,
        ingredients: testIngredients,
      );

      test('should return the same FavoriteMeal when no parameters are provided', () {
        final copiedMeal = originalMeal.copyWith();

        expect(copiedMeal.id, equals(originalMeal.id));
        expect(copiedMeal.name, equals(originalMeal.name));
        expect(copiedMeal.thumbnail, equals(originalMeal.thumbnail));
        expect(copiedMeal.category, equals(originalMeal.category));
        expect(copiedMeal.instructions, equals(originalMeal.instructions));
        expect(copiedMeal.ingredients, equals(originalMeal.ingredients));
      });

      test('should update only the specified parameters', () {
        const newName = 'Updated Meal Name';
        const newCategory = 'Updated Category';

        final copiedMeal = originalMeal.copyWith(
          name: newName,
          category: newCategory,
        );

        expect(copiedMeal.id, equals(originalMeal.id));
        expect(copiedMeal.name, equals(newName));
        expect(copiedMeal.thumbnail, equals(originalMeal.thumbnail));
        expect(copiedMeal.category, equals(newCategory));
        expect(copiedMeal.instructions, equals(originalMeal.instructions));
        expect(copiedMeal.ingredients, equals(originalMeal.ingredients));
      });

      test('should update all parameters when provided', () {
        const newId = 'new-id-456';
        const newName = 'Completely New Meal';
        const newThumbnail = 'https://example.com/new-image.jpg';
        const newCategory = 'New Category';
        const newInstructions = 'New instructions';
        const newIngredients = {'newIngredient': 'newAmount'};

        final copiedMeal = originalMeal.copyWith(
          id: newId,
          name: newName,
          thumbnail: newThumbnail,
          category: newCategory,
          instructions: newInstructions,
          ingredients: newIngredients,
        );

        expect(copiedMeal.id, equals(newId));
        expect(copiedMeal.name, equals(newName));
        expect(copiedMeal.thumbnail, equals(newThumbnail));
        expect(copiedMeal.category, equals(newCategory));
        expect(copiedMeal.instructions, equals(newInstructions));
        expect(copiedMeal.ingredients, equals(newIngredients));
      });
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        const meal1 = Meal(
          id: testId,
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        const meal2 = Meal(
          id: testId,
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        expect(meal1, equals(meal2));
        expect(meal1.hashCode, equals(meal2.hashCode));
      });

      test('should not be equal when properties are different', () {
        const meal1 = Meal(
          id: testId,
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        const meal2 = Meal(
          id: 'different-id',
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        expect(meal1, isNot(equals(meal2)));
        expect(meal1.hashCode, isNot(equals(meal2.hashCode)));
      });

      test('should not be equal when ingredients are different', () {
        const meal1 = Meal(
          id: testId,
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        const meal2 = Meal(
          id: testId,
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: {'different': 'ingredient'},
        );

        expect(meal1, isNot(equals(meal2)));
      });
    });

    group('Props', () {
      test('should contain all properties in props list', () {
        const meal = Meal(
          id: testId,
          name: testName,
          thumbnail: testThumbnail,
          category: testCategory,
          instructions: testInstructions,
          ingredients: testIngredients,
        );

        expect(meal.props, contains(testId));
        expect(meal.props, contains(testName));
        expect(meal.props, contains(testThumbnail));
        expect(meal.props, contains(testCategory));
        expect(meal.props, contains(testInstructions));
        expect(meal.props, contains(testIngredients));
      });
    });
  });
}
