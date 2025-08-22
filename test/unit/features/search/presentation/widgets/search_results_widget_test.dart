import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_results_widget.dart';

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
  group('SearchResultsWidget Unit Tests', () {
    group('Constructor', () {
      test('should create SearchResultsWidget with required parameters', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken')];
        const query = 'chicken';

        final widget = SearchResultsWidget(
          meals: meals,
          query: query,
        );

        expect(widget.meals, equals(meals));
        expect(widget.query, equals(query));
      });

      test('should create SearchResultsWidget with empty meals list', () {
        const query = 'chicken';

        const widget = SearchResultsWidget(
          meals: [],
          query: query,
        );

        expect(widget.meals, isEmpty);
        expect(widget.query, equals(query));
      });

      test('should create SearchResultsWidget with empty query', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken')];

        final widget = SearchResultsWidget(
          meals: meals,
          query: '',
        );

        expect(widget.meals, equals(meals));
        expect(widget.query, isEmpty);
      });

      test('should create SearchResultsWidget with many meals', () {
        final meals = List.generate(
          10,
          (index) => buildTestMeal(
            id: index.toString(),
            name: 'Meal $index',
          ),
        );
        const query = 'meal';

        final widget = SearchResultsWidget(
          meals: meals,
          query: query,
        );

        expect(widget.meals, hasLength(10));
        expect(widget.query, equals(query));
      });
    });

    group('Widget Properties', () {
      test('should have correct key when provided', () {
        const key = Key('test_key');
        const widget = SearchResultsWidget(
          meals: [],
          query: 'test',
          key: key,
        );

        expect(widget.key, equals(key));
      });

      test('should have null key when not provided', () {
        const widget = SearchResultsWidget(
          meals: [],
          query: 'test',
        );

        expect(widget.key, isNull);
      });

      test('should have correct meals list reference', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken')];
        final widget = SearchResultsWidget(
          meals: meals,
          query: 'chicken',
        );

        expect(identical(widget.meals, meals), isTrue);
      });

      test('should have correct query string reference', () {
        const query = 'chicken pasta';
        const widget = SearchResultsWidget(
          meals: [],
          query: query,
        );

        expect(identical(widget.query, query), isTrue);
      });
    });

    group('Data Validation', () {
      test('should handle null meals list gracefully', () {
        // Aunque esto no debería pasar en la práctica, probamos que no falle
        expect(
          () => const SearchResultsWidget(
            meals: <Meal>[],
            query: 'test',
          ),
          returnsNormally,
        );
      });

      test('should handle meals with empty data', () {
        final meals = [
          buildTestMeal(id: '', name: ''),
          buildTestMeal(id: '1', name: 'Chicken'),
        ];

        final widget = SearchResultsWidget(
          meals: meals,
          query: 'test',
        );

        expect(widget.meals, equals(meals));
        expect(widget.meals, hasLength(2));
      });

      test('should handle query with special characters', () {
        const specialQuery = 'chicken & pasta (special) [123]';
        const widget = SearchResultsWidget(
          meals: [],
          query: specialQuery,
        );

        expect(widget.query, equals(specialQuery));
      });

      test('should handle query with numbers', () {
        const numericQuery = 'chicken123';
        const widget = SearchResultsWidget(
          meals: [],
          query: numericQuery,
        );

        expect(widget.query, equals(numericQuery));
      });

      test('should handle very long query', () {
        final longQuery = 'a' * 1000;
        final widget = SearchResultsWidget(
          meals: const [],
          query: longQuery,
        );

        expect(widget.query, equals(longQuery));
        expect(widget.query.length, equals(1000));
      });
    });

    group('Widget Structure', () {
      test('should be a StatelessWidget', () {
        const widget = SearchResultsWidget(
          meals: [],
          query: 'test',
        );

        expect(widget, isA<StatelessWidget>());
      });

      test('should have correct runtime type', () {
        const widget = SearchResultsWidget(
          meals: [],
          query: 'test',
        );

        expect(widget.runtimeType, equals(SearchResultsWidget));
      });

      test('should be immutable', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken')];
        final widget = SearchResultsWidget(
          meals: meals,
          query: 'chicken',
        );

        expect(widget, isA<StatelessWidget>());
        // StatelessWidget es inmutable por definición
      });
    });

    group('Edge Cases', () {
      test('should handle meals list with duplicate IDs', () {
        final meals = [
          buildTestMeal(id: '1', name: 'Chicken'),
          buildTestMeal(id: '1', name: 'Chicken Pasta'),
        ];

        final widget = SearchResultsWidget(
          meals: meals,
          query: 'chicken',
        );

        expect(widget.meals, hasLength(2));
        expect(widget.meals[0].id, equals(widget.meals[1].id));
      });

      test('should handle meals list with very long names', () {
        final longName = 'a' * 500;
        final meals = [buildTestMeal(id: '1', name: longName)];

        final widget = SearchResultsWidget(
          meals: meals,
          query: 'test',
        );

        expect(widget.meals.first.name, equals(longName));
        expect(widget.meals.first.name.length, equals(500));
      });

      test('should handle query that matches meal names exactly', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken Pasta')];
        const query = 'Chicken Pasta';

        final widget = SearchResultsWidget(
          meals: meals,
          query: query,
        );

        expect(widget.query, equals(query));
        expect(widget.meals.first.name, equals(query));
      });

      test('should handle case sensitive query', () {
        final meals = [buildTestMeal(id: '1', name: 'Chicken Pasta')];
        const query = 'CHICKEN PASTA';

        final widget = SearchResultsWidget(
          meals: meals,
          query: query,
        );

        expect(widget.query, equals(query));
        expect(widget.query, isNot(equals(widget.meals.first.name)));
      });
    });
  });
}
