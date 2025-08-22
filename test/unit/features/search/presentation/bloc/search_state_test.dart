import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';

// Helper para crear Meal de prueba
Meal buildTestMeal({
  required String id,
  required String name,
  String? thumbnail,
  String? category,
  String? instructions,
  Map<String, String>? ingredients,
}) {
  return Meal(
    id: id,
    name: name,
    thumbnail: thumbnail ?? 'https://example.com/$id.jpg',
    category: category ?? 'Category $id',
    instructions: instructions ?? 'Instructions for $name',
    ingredients: ingredients ?? {'ingredient1': 'amount1'},
  );
}

void main() {
  group('SearchState', () {
    group('Constructor', () {
      test('should create initial state with default values', () {
        const state = SearchState();

        expect(state.status, equals(SearchStatus.initial));
        expect(state.meals, equals([]));
        expect(state.query, equals(''));
        expect(state.errorMessage, isNull);
      });

      test('should create initial state with named constructor', () {
        const state = SearchState.initial();

        expect(state.status, equals(SearchStatus.initial));
        expect(state.meals, equals([]));
        expect(state.query, equals(''));
        expect(state.errorMessage, isNull);
      });

      test('should create state with custom values', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken')];
        final state = SearchState(
          status: SearchStatus.success,
          meals: meals,
          query: 'chicken',
          errorMessage: 'No error',
        );

        expect(state.status, equals(SearchStatus.success));
        expect(state.meals, equals(meals));
        expect(state.query, equals('chicken'));
        expect(state.errorMessage, equals('No error'));
      });
    });

    group('copyWith', () {
      const initialState = SearchState();

      test('should return same state when no parameters are provided', () {
        final newState = initialState.copyWith();

        expect(newState, equals(initialState));
      });

      test('should update status only', () {
        final newState = initialState.copyWith(status: SearchStatus.loading);

        expect(newState.status, equals(SearchStatus.loading));
        expect(newState.meals, equals(initialState.meals));
        expect(newState.query, equals(initialState.query));
        expect(newState.errorMessage, equals(initialState.errorMessage));
      });

      test('should update meals only', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken')];
        final newState = initialState.copyWith(meals: meals);

        expect(newState.status, equals(initialState.status));
        expect(newState.meals, equals(meals));
        expect(newState.query, equals(initialState.query));
        expect(newState.errorMessage, equals(initialState.errorMessage));
      });

      test('should update query only', () {
        final newState = initialState.copyWith(query: 'chicken');

        expect(newState.status, equals(initialState.status));
        expect(newState.meals, equals(initialState.meals));
        expect(newState.query, equals('chicken'));
        expect(newState.errorMessage, equals(initialState.errorMessage));
      });

      test('should update errorMessage only', () {
        final newState = initialState.copyWith(errorMessage: 'API Error');

        expect(newState.status, equals(initialState.status));
        expect(newState.meals, equals(initialState.meals));
        expect(newState.query, equals(initialState.query));
        expect(newState.errorMessage, equals('API Error'));
      });

      test('should update multiple fields', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken')];
        final newState = initialState.copyWith(
          status: SearchStatus.success,
          meals: meals,
          query: 'chicken',
        );

        expect(newState.status, equals(SearchStatus.success));
        expect(newState.meals, equals(meals));
        expect(newState.query, equals('chicken'));
        expect(newState.errorMessage, equals(initialState.errorMessage));
      });

      test('should clear errorMessage when clearErrorMessage is true', () {
        const stateWithError = SearchState(
          status: SearchStatus.failure,
          errorMessage: 'API Error',
        );
        final newState = stateWithError.copyWith(clearErrorMessage: true);

        expect(newState.errorMessage, isNull);
      });
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        final state1 = SearchState(
          status: SearchStatus.success,
          meals: [buildTestMeal(id: '1', name: 'Chicken')],
          query: 'chicken',
        );
        final state2 = SearchState(
          status: SearchStatus.success,
          meals: [buildTestMeal(id: '1', name: 'Chicken')],
          query: 'chicken',
        );

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when status is different', () {
        const state1 = SearchState(status: SearchStatus.loading);
        const state2 = SearchState(status: SearchStatus.success);

        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when meals are different', () {
        final state1 = SearchState(
          meals: [buildTestMeal(id: '1', name: 'Chicken')],
        );
        final state2 = SearchState(
          meals: [buildTestMeal(id: '2', name: 'Pasta')],
        );

        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when query is different', () {
        const state1 = SearchState(query: 'chicken');
        const state2 = SearchState(query: 'pasta');

        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when errorMessage is different', () {
        const state1 = SearchState(errorMessage: 'Error 1');
        const state2 = SearchState(errorMessage: 'Error 2');

        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when one has errorMessage and other does not', () {
        const state1 = SearchState(errorMessage: 'Error');
        const state2 = SearchState();

        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });
    });

    group('Props', () {
      test('should return correct props list', () {
        final state = SearchState(
          status: SearchStatus.success,
          meals: [buildTestMeal(id: '1', name: 'Chicken')],
          query: 'chicken',
          errorMessage: 'No error',
        );

        expect(
          state.props,
          equals([
            SearchStatus.success,
            [buildTestMeal(id: '1', name: 'Chicken')],
            'chicken',
            'No error',
          ]),
        );
      });

      test('should handle empty props correctly', () {
        const state = SearchState.initial();

        expect(
          state.props,
          equals([
            SearchStatus.initial,
            <Meal>[],
            '',
            null,
          ]),
        );
      });
    });

    group('SearchStatus enum', () {
      test('should have correct values', () {
        expect(
          SearchStatus.values,
          containsAll([
            SearchStatus.initial,
            SearchStatus.loading,
            SearchStatus.success,
            SearchStatus.failure,
          ]),
        );
      });

      test('should have correct number of values', () {
        expect(SearchStatus.values.length, equals(4));
      });
    });
  });
}
