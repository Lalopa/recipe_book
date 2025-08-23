import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/models/objectbox/meal_objectbox_model.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

void main() {
  group('MealObjectBoxModel', () {
    late MealModel testMeal;
    late MealObjectBoxModel testObjectBoxModel;

    setUp(() {
      testMeal = const MealModel(
        id: 'test-id',
        name: 'Test Meal',
        thumbnail: 'test-thumbnail.jpg',
        category: 'Test Category',
        instructions: 'Test Instructions',
        ingredients: {
          'ingredient1': 'amount1',
          'ingredient2': 'amount2',
        },
      );

      testObjectBoxModel = MealObjectBoxModel(
        mealId: 'test-id',
        name: 'Test Meal',
        thumbnail: 'test-thumbnail.jpg',
        category: 'Test Category',
        instructions: 'Test Instructions',
        ingredientsJson: '{"ingredient1":"amount1","ingredient2":"amount2"}',
        timestamp: DateTime(2023),
        expiresAt: DateTime(2023, 12, 31),
      );
    });

    group('Constructor', () {
      test('should create instance with all required parameters', () {
        final model = MealObjectBoxModel(
          mealId: 'test-id',
          name: 'Test Meal',
          category: 'Test Category',
          instructions: 'Test Instructions',
          ingredientsJson: '{"ingredient1":"amount1"}',
          timestamp: DateTime(2023),
        );

        expect(model.mealId, 'test-id');
        expect(model.name, 'Test Meal');
        expect(model.category, 'Test Category');
        expect(model.instructions, 'Test Instructions');
        expect(model.ingredientsJson, '{"ingredient1":"amount1"}');
        expect(model.timestamp, DateTime(2023));
        expect(model.id, 0);
        expect(model.thumbnail, isNull);
        expect(model.expiresAt, isNull);
      });

      test('should create instance with optional parameters', () {
        final model = MealObjectBoxModel(
          mealId: 'test-id',
          name: 'Test Meal',
          category: 'Test Category',
          instructions: 'Test Instructions',
          ingredientsJson: '{"ingredient1":"amount1"}',
          timestamp: DateTime(2023),
          id: 123,
          thumbnail: 'test-thumbnail.jpg',
          expiresAt: DateTime(2023, 12, 31),
        );

        expect(model.id, 123);
        expect(model.thumbnail, 'test-thumbnail.jpg');
        expect(model.expiresAt, DateTime(2023, 12, 31));
      });
    });

    group('fromMealModel factory', () {
      test('should create ObjectBox model from MealModel without TTL', () {
        final objectBoxModel = MealObjectBoxModel.fromMealModel(testMeal);

        expect(objectBoxModel.mealId, testMeal.id);
        expect(objectBoxModel.name, testMeal.name);
        expect(objectBoxModel.thumbnail, testMeal.thumbnail);
        expect(objectBoxModel.category, testMeal.category);
        expect(objectBoxModel.instructions, testMeal.instructions);
        expect(objectBoxModel.ingredientsJson, '{"ingredient1":"amount1","ingredient2":"amount2"}');
        expect(objectBoxModel.timestamp, isA<DateTime>());
        expect(objectBoxModel.expiresAt, isNull);
      });

      test('should create ObjectBox model from MealModel with TTL', () {
        const ttl = Duration(hours: 24);
        final objectBoxModel = MealObjectBoxModel.fromMealModel(testMeal, ttl: ttl);

        expect(objectBoxModel.expiresAt, isNotNull);
        expect(objectBoxModel.expiresAt!.isAfter(DateTime.now()), isTrue);
        expect(objectBoxModel.expiresAt!.difference(DateTime.now()).inHours, closeTo(24, 1));
      });

      test('should handle empty ingredients map', () {
        const mealWithEmptyIngredients = MealModel(
          id: 'test-id',
          name: 'Test Meal',
          thumbnail: 'test-thumbnail.jpg',
          category: 'Test Category',
          instructions: 'Test Instructions',
        );

        final objectBoxModel = MealObjectBoxModel.fromMealModel(mealWithEmptyIngredients);

        expect(objectBoxModel.ingredientsJson, '{}');
      });
    });

    group('toMealModel', () {
      test('should convert ObjectBox model to MealModel', () {
        final mealModel = testObjectBoxModel.toMealModel();

        expect(mealModel.id, testObjectBoxModel.mealId);
        expect(mealModel.name, testObjectBoxModel.name);
        expect(mealModel.thumbnail, testObjectBoxModel.thumbnail);
        expect(mealModel.category, testObjectBoxModel.category);
        expect(mealModel.instructions, testObjectBoxModel.instructions);
        expect(mealModel.ingredients, {
          'ingredient1': 'amount1',
          'ingredient2': 'amount2',
        });
      });
    });

    group('isExpired getter', () {
      test('should return false when expiresAt is null', () {
        final model = MealObjectBoxModel(
          mealId: 'test-id',
          name: 'Test Meal',
          category: 'Test Category',
          instructions: 'Test Instructions',
          ingredientsJson: '{"ingredient1":"amount1"}',
          timestamp: DateTime(2023),
        );

        expect(model.isExpired, isFalse);
      });

      test('should return false when expiresAt is in the future', () {
        final model = MealObjectBoxModel(
          mealId: 'test-id',
          name: 'Test Meal',
          category: 'Test Category',
          instructions: 'Test Instructions',
          ingredientsJson: '{"ingredient1":"amount1"}',
          timestamp: DateTime(2023),
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        );

        expect(model.isExpired, isFalse);
      });

      test('should return true when expiresAt is in the past', () {
        final model = MealObjectBoxModel(
          mealId: 'test-id',
          name: 'Test Meal',
          category: 'Test Category',
          instructions: 'Test Instructions',
          ingredientsJson: '{"ingredient1":"amount1"}',
          timestamp: DateTime(2023),
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        );

        expect(model.isExpired, isTrue);
      });
    });

    group('_mapToJson static method', () {
      test('should convert ingredients map to JSON string', () {
        final ingredients = {
          'ingredient1': 'amount1',
          'ingredient2': 'amount2',
        };

        final result = MealObjectBoxModel.mapToJson(ingredients);

        expect(result, '{"ingredient1":"amount1","ingredient2":"amount2"}');
      });

      test('should handle empty ingredients map', () {
        final ingredients = <String, String>{};

        final result = MealObjectBoxModel.mapToJson(ingredients);

        expect(result, '{}');
      });

      test('should handle single ingredient', () {
        final ingredients = {'ingredient1': 'amount1'};

        final result = MealObjectBoxModel.mapToJson(ingredients);

        expect(result, '{"ingredient1":"amount1"}');
      });
    });

    group('jsonToMap static method', () {
      test('should convert valid JSON string to ingredients map', () {
        const json = '{"ingredient1":"amount1","ingredient2":"amount2"}';

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, {
          'ingredient1': 'amount1',
          'ingredient2': 'amount2',
        });
      });

      test('should handle empty JSON string', () {
        const json = '';

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, isEmpty);
      });

      test('should handle empty JSON object string', () {
        const json = '{}';

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, isEmpty);
      });

      test('should handle JSON object with empty content', () {
        const json = '{""}';

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, isEmpty);
      });

      test('should handle single ingredient JSON', () {
        const json = '{"ingredient1":"amount1"}';

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, {'ingredient1': 'amount1'});
      });

      test('should handle malformed JSON gracefully', () {
        const json = '{"ingredient1":"amount1",}'; // Extra comma at end

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, {'ingredient1': 'amount1'});
      });

      test('should handle JSON with missing colon', () {
        const json = '{"ingredient1"amount1"}'; // Missing colon

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, isEmpty);
      });

      test('should handle JSON with colon at beginning', () {
        const json = '{:ingredient1":"amount1"}'; // Colon at beginning

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, isEmpty);
      });

      test('should handle JSON with complex ingredient names and amounts', () {
        const json = '{"ingredient with spaces":"amount with spaces","another-ingredient":"another-amount"}';

        final result = MealObjectBoxModel.jsonToMap(json);

        expect(result, {
          'ingredient with spaces': 'amount with spaces',
          'another-ingredient': 'another-amount',
        });
      });
    });
  });
}
