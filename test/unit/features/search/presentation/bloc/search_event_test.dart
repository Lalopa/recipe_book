import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';

void main() {
  group('SearchEvent', () {
    group('SearchQueryChanged', () {
      test('should create SearchQueryChanged event with query', () {
        const query = 'chicken';
        const event = SearchQueryChanged(query);

        expect(event.query, equals(query));
      });

      test('should have correct props', () {
        const query = 'pasta';
        const event = SearchQueryChanged(query);

        expect(event.props, equals([query]));
      });

      test('should be equal when query is the same', () {
        const event1 = SearchQueryChanged('chicken');
        const event2 = SearchQueryChanged('chicken');

        expect(event1, equals(event2));
      });

      test('should not be equal when query is different', () {
        const event1 = SearchQueryChanged('chicken');
        const event2 = SearchQueryChanged('pasta');

        expect(event1, isNot(equals(event2)));
      });

      test('should handle empty query', () {
        const event = SearchQueryChanged('');

        expect(event.query, equals(''));
      });

      test('should handle whitespace query', () {
        const event = SearchQueryChanged('   ');

        expect(event.query, equals('   '));
      });

      test('should handle special characters', () {
        const event = SearchQueryChanged('chicken & pasta');

        expect(event.query, equals('chicken & pasta'));
      });

      test('should handle numbers', () {
        const event = SearchQueryChanged('chicken123');

        expect(event.query, equals('chicken123'));
      });

      test('should handle very long query', () {
        final longQuery = 'a' * 1000;
        final event = SearchQueryChanged(longQuery);

        expect(event.query, equals(longQuery));
      });
    });

    group('SearchCleared', () {
      test('should create SearchCleared event', () {
        const event = SearchCleared();

        expect(event, isA<SearchCleared>());
      });

      test('should have empty props', () {
        const event = SearchCleared();

        expect(event.props, equals([]));
      });

      test('should be equal to other SearchCleared events', () {
        const event1 = SearchCleared();
        const event2 = SearchCleared();

        expect(event1, equals(event2));
      });

      test('should not be equal to SearchQueryChanged events', () {
        const event1 = SearchCleared();
        const event2 = SearchQueryChanged('chicken');

        expect(event1, isNot(equals(event2)));
      });
    });

    group('Event equality', () {
      test('SearchQueryChanged events with same query should be equal', () {
        const event1 = SearchQueryChanged('chicken');
        const event2 = SearchQueryChanged('chicken');

        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('SearchQueryChanged events with different queries should not be equal', () {
        const event1 = SearchQueryChanged('chicken');
        const event2 = SearchQueryChanged('pasta');

        expect(event1, isNot(equals(event2)));
        expect(event1.hashCode, isNot(equals(event2.hashCode)));
      });

      test('SearchCleared events should always be equal', () {
        const event1 = SearchCleared();
        const event2 = SearchCleared();

        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('Different event types should not be equal', () {
        const queryEvent = SearchQueryChanged('chicken');
        const clearEvent = SearchCleared();

        expect(queryEvent, isNot(equals(clearEvent)));
        expect(queryEvent.hashCode, isNot(equals(clearEvent.hashCode)));
      });
    });
  });
}
