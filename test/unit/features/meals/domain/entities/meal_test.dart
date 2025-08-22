import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

void main() {
  group('Meal', () {
    test('should create a meal with required parameters', () {
      const meal = Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
      );

      expect(meal.id, '1');
      expect(meal.name, 'Test Meal');
      expect(meal.thumbnail, 'https://example.com/image.jpg');
      expect(meal.category, 'Test Category');
      expect(meal.instructions, 'Test instructions');
      expect(meal.ingredients, {'ingredient1': 'measure1'});
      expect(meal.isFavorite, false);
    });

    test('should create a meal with custom isFavorite value', () {
      const meal = Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        isFavorite: true,
      );

      expect(meal.isFavorite, true);
    });

    test('should create an empty meal', () {
      const meal = Meal.empty();

      expect(meal.id, '');
      expect(meal.name, '');
      expect(meal.thumbnail, null);
      expect(meal.category, '');
      expect(meal.instructions, '');
      expect(meal.ingredients, isEmpty);
      expect(meal.isFavorite, false);
    });

    test('should return correct props', () {
      const meal = Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        isFavorite: true,
      );

      expect(meal.props, [
        '1',
        'Test Meal',
        'https://example.com/image.jpg',
        'Test Category',
        'Test instructions',
        {'ingredient1': 'measure1'},
        true,
      ]);
    });

    test('should be equal when all properties are the same', () {
      const meal1 = Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        isFavorite: true,
      );

      const meal2 = Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        isFavorite: true,
      );

      expect(meal1, equals(meal2));
    });

    test('should not be equal when properties are different', () {
      const meal1 = Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        isFavorite: true,
      );

      const meal2 = Meal(
        id: '2',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
        isFavorite: true,
      );

      expect(meal1, isNot(equals(meal2)));
    });
  });
}
