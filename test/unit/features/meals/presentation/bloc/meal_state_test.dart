import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

void main() {
  group('MealState', () {
    test('should support equality', () {
      const state1 = MealState(
        status: MealStatus.initial,
        meals: [],
        letterIndex: 0,
        offsetInLetter: 0,
        hasReachedMax: false,
      );
      const state2 = MealState(
        status: MealStatus.initial,
        meals: [],
        letterIndex: 0,
        offsetInLetter: 0,
        hasReachedMax: false,
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('should support inequality', () {
      const state1 = MealState(
        status: MealStatus.initial,
        meals: [],
        letterIndex: 0,
        offsetInLetter: 0,
        hasReachedMax: false,
      );
      const state2 = MealState(
        status: MealStatus.loading,
        meals: [],
        letterIndex: 0,
        offsetInLetter: 0,
        hasReachedMax: false,
      );

      expect(state1, isNot(equals(state2)));
    });

    test('should support copyWith', () {
      const originalState = MealState(
        status: MealStatus.initial,
        meals: [],
        letterIndex: 0,
        offsetInLetter: 0,
        hasReachedMax: false,
      );

      final updatedState = originalState.copyWith(
        status: MealStatus.loading,
        meals: [
          const Meal(
            id: '1',
            name: 'Test Meal',
            thumbnail: 'test.jpg',
            category: 'Test Category',
            instructions: 'Test instructions',
            ingredients: {'ingredient1': 'measure1'},
          ),
        ],
        letterIndex: 1,
        offsetInLetter: 5,
        hasReachedMax: true,
      );

      expect(updatedState.status, equals(MealStatus.loading));
      expect(updatedState.meals.length, equals(1));
      expect(updatedState.letterIndex, equals(1));
      expect(updatedState.offsetInLetter, equals(5));
      expect(updatedState.hasReachedMax, isTrue);
    });

    test('should support partial copyWith', () {
      const originalState = MealState(
        status: MealStatus.initial,
        meals: [],
        letterIndex: 0,
        offsetInLetter: 0,
        hasReachedMax: false,
      );

      final updatedState = originalState.copyWith(
        status: MealStatus.loading,
      );

      expect(updatedState.status, equals(MealStatus.loading));
      expect(updatedState.meals, equals(originalState.meals));
      expect(updatedState.letterIndex, equals(originalState.letterIndex));
      expect(updatedState.offsetInLetter, equals(originalState.offsetInLetter));
      expect(updatedState.hasReachedMax, equals(originalState.hasReachedMax));
    });

    test('should have correct initial state', () {
      const initialState = MealState.initial();

      expect(initialState.status, equals(MealStatus.initial));
      expect(initialState.meals, equals([]));
      expect(initialState.letterIndex, equals(0));
      expect(initialState.offsetInLetter, equals(0));
      expect(initialState.hasReachedMax, isFalse);
    });

    test('should include all properties in props', () {
      const state = MealState(
        status: MealStatus.success,
        meals: <Meal>[],
        letterIndex: 1,
        offsetInLetter: 5,
        hasReachedMax: true,
      );

      expect(
        state.props,
        containsAll([
          MealStatus.success,
          <Meal>[],
          1,
          5,
          true,
        ]),
      );
    });

    test('should handle empty meals list', () {
      const state = MealState(
        status: MealStatus.success,
        meals: [],
        letterIndex: 0,
        offsetInLetter: 0,
        hasReachedMax: false,
      );

      expect(state.meals, isEmpty);
      expect(state.meals.length, equals(0));
    });

    test('should handle meals with data', () {
      final meals = [
        const Meal(
          id: '1',
          name: 'Test Meal 1',
          thumbnail: 'test1.jpg',
          category: 'Test Category 1',
          instructions: 'Test instructions 1',
          ingredients: {'ingredient1': 'measure1'},
        ),
        const Meal(
          id: '2',
          name: 'Test Meal 2',
          thumbnail: 'test2.jpg',
          category: 'Test Category 2',
          instructions: 'Test instructions 2',
          ingredients: {'ingredient2': 'measure2'},
        ),
      ];

      final state = MealState(
        status: MealStatus.success,
        meals: meals,
        letterIndex: 1,
        offsetInLetter: 0,
        hasReachedMax: false,
      );

      expect(state.meals, equals(meals));
      expect(state.meals.length, equals(2));
      expect(state.meals.first.name, equals('Test Meal 1'));
      expect(state.meals.last.name, equals('Test Meal 2'));
    });

    test('should handle pagination state', () {
      const state = MealState(
        status: MealStatus.success,
        meals: [],
        letterIndex: 5,
        offsetInLetter: 10,
        hasReachedMax: false,
      );

      expect(state.letterIndex, equals(5));
      expect(state.offsetInLetter, equals(10));
      expect(state.hasReachedMax, isFalse);
    });

    test('should handle max reached state', () {
      const state = MealState(
        status: MealStatus.success,
        meals: [],
        letterIndex: 26,
        offsetInLetter: 0,
        hasReachedMax: true,
      );

      expect(state.letterIndex, equals(26));
      expect(state.hasReachedMax, isTrue);
    });
  });
}
