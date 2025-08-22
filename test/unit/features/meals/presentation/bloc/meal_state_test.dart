import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

void main() {
  group('MealState', () {
    const testMeals = [
      Meal(
        id: '1',
        name: 'Test Meal 1',
        thumbnail: 'https://example.com/image1.jpg',
        category: 'Test Category',
        instructions: 'Test instructions 1',
        ingredients: {'ingredient1': 'measure1'},
      ),
      Meal(
        id: '2',
        name: 'Test Meal 2',
        thumbnail: 'https://example.com/image2.jpg',
        category: 'Test Category',
        instructions: 'Test instructions 2',
        ingredients: {'ingredient2': 'measure2'},
      ),
    ];

    group('MealState.initial', () {
      test('should create initial state with correct values', () {
        const state = MealState.initial();

        expect(state.status, MealStatus.initial);
        expect(state.meals, isEmpty);
        expect(state.letterIndex, 0);
        expect(state.offsetInLetter, 0);
        expect(state.hasReachedMax, false);
        expect(state.searchQuery, '');
        expect(state.searchResults, isEmpty);
      });
    });

    group('MealState constructor', () {
      test('should create state with custom values', () {
        const state = MealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 5,
          offsetInLetter: 10,
          hasReachedMax: true,
          searchQuery: 'pizza',
          searchResults: testMeals,
        );

        expect(state.status, MealStatus.success);
        expect(state.meals, testMeals);
        expect(state.letterIndex, 5);
        expect(state.offsetInLetter, 10);
        expect(state.hasReachedMax, true);
        expect(state.searchQuery, 'pizza');
        expect(state.searchResults, testMeals);
      });
    });

    group('copyWith', () {
      test('should return same instance when no parameters are provided', () {
        const state = MealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 1,
          offsetInLetter: 0,
          hasReachedMax: false,
          searchQuery: '',
          searchResults: [],
        );

        final newState = state.copyWith();

        expect(newState, equals(state));
      });

      test('should update only provided parameters', () {
        const state = MealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 1,
          offsetInLetter: 0,
          hasReachedMax: false,
          searchQuery: '',
          searchResults: [],
        );

        final newState = state.copyWith(
          status: MealStatus.loading,
          hasReachedMax: true,
        );

        expect(newState.status, MealStatus.loading);
        expect(newState.meals, testMeals);
        expect(newState.letterIndex, 1);
        expect(newState.offsetInLetter, 0);
        expect(newState.hasReachedMax, true);
        expect(newState.searchQuery, '');
        expect(newState.searchResults, isEmpty);
      });

      test('should update all parameters when provided', () {
        const state = MealState.initial();

        final newState = state.copyWith(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 5,
          offsetInLetter: 10,
          hasReachedMax: true,
          searchQuery: 'pizza',
          searchResults: testMeals,
        );

        expect(newState.status, MealStatus.success);
        expect(newState.meals, testMeals);
        expect(newState.letterIndex, 5);
        expect(newState.offsetInLetter, 10);
        expect(newState.hasReachedMax, true);
        expect(newState.searchQuery, 'pizza');
        expect(newState.searchResults, testMeals);
      });
    });

    group('props', () {
      test('should return correct props list', () {
        const state = MealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 5,
          offsetInLetter: 10,
          hasReachedMax: true,
          searchQuery: 'pizza',
          searchResults: testMeals,
        );

        expect(state.props, [
          MealStatus.success,
          testMeals,
          5,
          10,
          true,
          'pizza',
          testMeals,
        ]);
      });

      test('should return correct props for initial state', () {
        const state = MealState.initial();

        expect(state.props, [
          MealStatus.initial,
          <Meal>[],
          0,
          0,
          false,
          '',
          <Meal>[],
        ]);
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = MealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 1,
          offsetInLetter: 0,
          hasReachedMax: false,
          searchQuery: '',
          searchResults: [],
        );

        const state2 = MealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 1,
          offsetInLetter: 0,
          hasReachedMax: false,
          searchQuery: '',
          searchResults: [],
        );

        expect(state1, equals(state2));
      });

      test('should not be equal when properties are different', () {
        const state1 = MealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 1,
          offsetInLetter: 0,
          hasReachedMax: false,
          searchQuery: '',
          searchResults: [],
        );

        const state2 = MealState(
          status: MealStatus.loading,
          meals: testMeals,
          letterIndex: 1,
          offsetInLetter: 0,
          hasReachedMax: false,
          searchQuery: '',
          searchResults: [],
        );

        expect(state1, isNot(equals(state2)));
      });
    });

    group('MealStatus', () {
      test('should have correct enum values', () {
        expect(MealStatus.values, [
          MealStatus.initial,
          MealStatus.loading,
          MealStatus.success,
          MealStatus.failure,
        ]);
      });

      test('should have correct string representations', () {
        expect(MealStatus.initial.toString(), 'MealStatus.initial');
        expect(MealStatus.loading.toString(), 'MealStatus.loading');
        expect(MealStatus.success.toString(), 'MealStatus.success');
        expect(MealStatus.failure.toString(), 'MealStatus.failure');
      });
    });
  });
}
