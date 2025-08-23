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

    test('all events should extend Equatable', () {
      const events = [
        MealFetched(),
        MealRefreshed(),
      ];

      for (final event in events) {
        expect(event, isA<MealEvent>());
      }
    });
  });
}
