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

    test('should create empty meal with correct default values', () {
      const meal = Meal.empty();

      expect(meal.id, isEmpty);
      expect(meal.name, isEmpty);
      expect(meal.thumbnail, isNull);
      expect(meal.category, isEmpty);
      expect(meal.instructions, isEmpty);
      expect(meal.ingredients, isEmpty);
      expect(meal.isFavorite, false);
    });

    test('should create empty meal that is not equal to regular meal', () {
      const emptyMeal = Meal.empty();
      const regularMeal = Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/image.jpg',
        category: 'Test Category',
        instructions: 'Test instructions',
        ingredients: {'ingredient1': 'measure1'},
      );

      expect(emptyMeal, isNot(equals(regularMeal)));
    });

    test('should create empty meal that is equal to another empty meal', () {
      const emptyMeal1 = Meal.empty();
      const emptyMeal2 = Meal.empty();

      expect(emptyMeal1, equals(emptyMeal2));
    });

    test('should create empty meal with correct props', () {
      const meal = Meal.empty();

      expect(meal.props, ['', '', null, '', '', isEmpty, false]);
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

    group('copyWith', () {
      late Meal originalMeal;

      setUp(() {
        originalMeal = const Meal(
          id: '1',
          name: 'Original Meal',
          thumbnail: 'https://example.com/original.jpg',
          category: 'Original Category',
          instructions: 'Original instructions',
          ingredients: {'original': 'measure'},
        );
      });

      test('should return same instance when no parameters are provided', () {
        final copiedMeal = originalMeal.copyWith();

        expect(copiedMeal, isNot(same(originalMeal)));
        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, originalMeal.name);
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, originalMeal.category);
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, originalMeal.isFavorite);
      });

      test('should update id when provided', () {
        final copiedMeal = originalMeal.copyWith(id: '2');

        expect(copiedMeal.id, '2');
        expect(copiedMeal.name, originalMeal.name);
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, originalMeal.category);
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, originalMeal.isFavorite);
      });

      test('should update name when provided', () {
        final copiedMeal = originalMeal.copyWith(name: 'Updated Meal');

        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, 'Updated Meal');
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, originalMeal.category);
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, originalMeal.isFavorite);
      });

      test('should update thumbnail when provided', () {
        final copiedMeal = originalMeal.copyWith(thumbnail: 'https://example.com/updated.jpg');

        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, originalMeal.name);
        expect(copiedMeal.thumbnail, 'https://example.com/updated.jpg');
        expect(copiedMeal.category, originalMeal.category);
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, originalMeal.isFavorite);
      });

      test('should update category when provided', () {
        final copiedMeal = originalMeal.copyWith(category: 'Updated Category');

        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, originalMeal.name);
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, 'Updated Category');
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, originalMeal.isFavorite);
      });

      test('should update instructions when provided', () {
        final copiedMeal = originalMeal.copyWith(instructions: 'Updated instructions');

        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, originalMeal.name);
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, originalMeal.category);
        expect(copiedMeal.instructions, 'Updated instructions');
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, originalMeal.isFavorite);
      });

      test('should update ingredients when provided', () {
        final newIngredients = {'new': 'measure', 'another': 'measure2'};
        final copiedMeal = originalMeal.copyWith(ingredients: newIngredients);

        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, originalMeal.name);
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, originalMeal.category);
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, newIngredients);
        expect(copiedMeal.isFavorite, originalMeal.isFavorite);
      });

      test('should update isFavorite when provided', () {
        final copiedMeal = originalMeal.copyWith(isFavorite: true);

        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, originalMeal.name);
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, originalMeal.category);
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, true);
      });

      test('should update multiple properties when provided', () {
        final copiedMeal = originalMeal.copyWith(
          name: 'Multi Updated',
          category: 'Multi Category',
          isFavorite: true,
        );

        expect(copiedMeal.id, originalMeal.id);
        expect(copiedMeal.name, 'Multi Updated');
        expect(copiedMeal.thumbnail, originalMeal.thumbnail);
        expect(copiedMeal.category, 'Multi Category');
        expect(copiedMeal.instructions, originalMeal.instructions);
        expect(copiedMeal.ingredients, originalMeal.ingredients);
        expect(copiedMeal.isFavorite, true);
      });

      test('should handle empty ingredients map correctly', () {
        final copiedMeal = originalMeal.copyWith(ingredients: {});

        expect(copiedMeal.ingredients, isEmpty);
      });
    });

    group('edge cases', () {
      test('should handle empty string values', () {
        const meal = Meal(
          id: '',
          name: '',
          thumbnail: null,
          category: '',
          instructions: '',
          ingredients: {},
        );

        expect(meal.id, isEmpty);
        expect(meal.name, isEmpty);
        expect(meal.thumbnail, isNull);
        expect(meal.category, isEmpty);
        expect(meal.instructions, isEmpty);
        expect(meal.ingredients, isEmpty);
        expect(meal.isFavorite, false);
      });

      test('should handle very long string values', () {
        final longString = 'a' * 1000;
        final meal = Meal(
          id: '1',
          name: longString,
          thumbnail: 'https://example.com/image.jpg',
          category: longString,
          instructions: longString,
          ingredients: const {'ingredient': 'measure'},
          isFavorite: true,
        );

        expect(meal.name, longString);
        expect(meal.category, longString);
        expect(meal.instructions, longString);
      });

      test('should handle special characters in strings', () {
        const specialString = r'!@#$%^&*()_+-=[]{}|;:,.<>?';
        const meal = Meal(
          id: '1',
          name: specialString,
          thumbnail: 'https://example.com/image.jpg',
          category: specialString,
          instructions: specialString,
          ingredients: {'ingredient': 'measure'},
        );

        expect(meal.name, specialString);
        expect(meal.category, specialString);
        expect(meal.instructions, specialString);
      });

      test('should handle unicode characters in strings', () {
        const unicodeString = 'ñáéíóúüÑÁÉÍÓÚÜ';
        const meal = Meal(
          id: '1',
          name: unicodeString,
          thumbnail: 'https://example.com/image.jpg',
          category: unicodeString,
          instructions: unicodeString,
          ingredients: {'ingredient': 'measure'},
        );

        expect(meal.name, unicodeString);
        expect(meal.category, unicodeString);
        expect(meal.instructions, unicodeString);
      });
    });
  });
}
