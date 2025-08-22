import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

void main() {
  group('MealModel', () {
    test('should create MealModel from JSON', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/image.jpg',
        'strCategory': 'Test Category',
        'strInstructions': 'Test instructions',
        'strIngredient1': 'ingredient1',
        'strMeasure1': 'measure1',
        'strIngredient2': 'ingredient2',
        'strMeasure2': 'measure2',
      };

      final result = MealModel.fromJson(json);

      expect(result.id, '1');
      expect(result.name, 'Test Meal');
      expect(result.thumbnail, 'https://example.com/image.jpg');
      expect(result.category, 'Test Category');
      expect(result.instructions, 'Test instructions');
      expect(result.ingredients, {
        'ingredient1': 'measure1',
        'ingredient2': 'measure2',
      });
    });

    test('should create MealModel with default values when fields are missing', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/image.jpg',
      };

      final result = MealModel.fromJson(json);

      expect(result.id, '1');
      expect(result.name, 'Test Meal');
      expect(result.thumbnail, 'https://example.com/image.jpg');
      expect(result.category, '');
      expect(result.instructions, '');
      expect(result.ingredients, isEmpty);
    });

    test('should handle empty ingredients', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/image.jpg',
      };

      final result = MealModel.fromJson(json);

      expect(result.ingredients, isEmpty);
    });

    test('should handle ingredients with empty values', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/image.jpg',
        'strIngredient1': '',
        'strMeasure1': '',
        'strIngredient2': '   ',
        'strMeasure2': '   ',
      };

      final result = MealModel.fromJson(json);

      expect(result.ingredients, isEmpty);
    });

    test('should handle ingredients with only ingredient name', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/image.jpg',
        'strIngredient1': 'ingredient1',
        'strMeasure1': '',
      };

      final result = MealModel.fromJson(json);

      expect(result.ingredients, {'ingredient1': ''});
    });

    test('should handle ingredients with only measure', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/image.jpg',
        'strIngredient1': '',
        'strMeasure1': 'measure1',
      };

      final result = MealModel.fromJson(json);

      expect(result.ingredients, isEmpty);
    });

    test('should handle up to 20 ingredients', () {
      final json = <String, dynamic>{
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/image.jpg',
      };

      // Add 20 ingredients
      for (var i = 1; i <= 20; i++) {
        json['strIngredient$i'] = 'ingredient$i';
        json['strMeasure$i'] = 'measure$i';
      }

      final result = MealModel.fromJson(json);

      expect(result.ingredients.length, 20);
      for (var i = 1; i <= 20; i++) {
        expect(result.ingredients['ingredient$i'], 'measure$i');
      }
    });

    test('should convert to entity correctly', () {
      const model = MealModel(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
      );

      final entity = model.toEntity();

      expect(entity.id, '1');
      expect(entity.name, 'Test Meal');
      expect(entity.thumbnail, 'https://example.com/image.jpg');
      expect(entity.category, 'Test Category');
      expect(entity.instructions, 'Test instructions');
      expect(entity.ingredients, {'ingredient1': 'measure1'});
      expect(entity.isFavorite, false);
    });

    test('should handle null thumbnail', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': null,
      };

      final result = MealModel.fromJson(json);

      expect(result.thumbnail, isNull);
    });

    test('should handle empty string thumbnail', () {
      final json = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': '',
      };

      final result = MealModel.fromJson(json);

      expect(result.thumbnail, '');
    });
  });
}
