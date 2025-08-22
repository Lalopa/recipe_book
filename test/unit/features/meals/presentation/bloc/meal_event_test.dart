import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

void main() {
  group('MealEvent', () {
    group('MealFetched', () {
      test('should be equal when instances are the same', () {
        const event1 = MealFetched();
        const event2 = MealFetched();

        expect(event1, equals(event2));
      });

      test('should have correct props', () {
        const event = MealFetched();
        expect(event.props, isEmpty);
      });
    });

    group('MealRefreshed', () {
      test('should be equal when instances are the same', () {
        const event1 = MealRefreshed();
        const event2 = MealRefreshed();

        expect(event1, equals(event2));
      });

      test('should have correct props', () {
        const event = MealRefreshed();
        expect(event.props, isEmpty);
      });
    });

    group('MealSearched', () {
      test('should be equal when instances have the same query', () {
        const event1 = MealSearched('pizza');
        const event2 = MealSearched('pizza');

        expect(event1, equals(event2));
      });

      test('should not be equal when instances have different queries', () {
        const event1 = MealSearched('pizza');
        const event2 = MealSearched('pasta');

        expect(event1, isNot(equals(event2)));
      });

      test('should have correct props', () {
        const event = MealSearched('pizza');
        expect(event.props, ['pizza']);
      });

      test('should handle empty query', () {
        const event = MealSearched('');
        expect(event.query, '');
        expect(event.props, ['']);
      });

      test('should handle special characters in query', () {
        const event = MealSearched('pizza & pasta');
        expect(event.query, 'pizza & pasta');
        expect(event.props, ['pizza & pasta']);
      });
    });

    group('MealSearchCleared', () {
      test('should be equal when instances are the same', () {
        const event1 = MealSearchCleared();
        const event2 = MealSearchCleared();

        expect(event1, equals(event2));
      });

      test('should have correct props', () {
        const event = MealSearchCleared();
        expect(event.props, isEmpty);
      });
    });

    test('all events should extend Equatable', () {
      const events = [
        MealFetched(),
        MealRefreshed(),
        MealSearched('test'),
        MealSearchCleared(),
      ];

      for (final event in events) {
        expect(event, isA<MealEvent>());
      }
    });
  });
}
