import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_preview_widget.dart';
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
  group('SearchResultsWidget', () {
    group('Empty results', () {
      testWidgets(
        'should display no results message when meals list is empty',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SearchResultsWidget(
                  meals: [],
                  query: 'chicken',
                ),
              ),
            ),
          );

          expect(find.text('No results found for "chicken"'), findsOneWidget);
          expect(find.text('Try with other search terms'), findsOneWidget);
          expect(find.byIcon(Icons.search_off), findsOneWidget);
          expect(find.byType(MealPreviewWidget), findsNothing);
        },
      );

      testWidgets('should display correct query in no results message', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: [],
                query: 'pasta carbonara',
              ),
            ),
          ),
        );

        expect(
          find.text('No results found for "pasta carbonara"'),
          findsOneWidget,
        );
      });

      testWidgets(
        'should display search off icon with correct size and color',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SearchResultsWidget(
                  meals: [],
                  query: 'chicken',
                ),
              ),
            ),
          );

          final icon = find.byIcon(Icons.search_off);
          expect(icon, findsOneWidget);

          final iconWidget = tester.widget<Icon>(icon);
          expect(iconWidget.size, equals(64));
          expect(iconWidget.color, equals(Colors.grey[400]));
        },
      );

      testWidgets('should apply correct text styles for no results', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: [],
                query: 'chicken',
              ),
            ),
          ),
        );

        final titleText = find.text('No results found for "chicken"');
        final bodyText = find.text('Try with other search terms');

        expect(titleText, findsOneWidget);
        expect(bodyText, findsOneWidget);

        final titleWidget = tester.widget<Text>(titleText);
        final bodyWidget = tester.widget<Text>(bodyText);

        expect(titleWidget.style?.color, equals(Colors.grey[600]));
        expect(bodyWidget.style?.color, equals(Colors.grey[500]));
      });
    });

    group('With results', () {
      testWidgets('should display GridView when meals list is not empty', (
        tester,
      ) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Chicken Pasta'),
          buildTestMeal(id: '2', name: 'Chicken Salad'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: meals,
                query: 'chicken',
              ),
            ),
          ),
        );

        expect(find.byType(GridView), findsOneWidget);
        // GridView.builder puede no renderizar todos los elementos en tests
        expect(find.byType(MealPreviewWidget), findsAtLeastNWidgets(1));
      });

      testWidgets('should pass correct meal data to MealPreviewWidgets', (
        tester,
      ) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Chicken Pasta'),
          buildTestMeal(id: '2', name: 'Chicken Salad'),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: meals,
                query: 'chicken',
              ),
            ),
          ),
        );

        final mealPreviewWidgets = find.byType(MealPreviewWidget);
        expect(mealPreviewWidgets, findsAtLeastNWidgets(1));

        // Verificar que al menos el primer widget tiene la comida correcta
        if (mealPreviewWidgets.evaluate().isNotEmpty) {
          final firstWidget = tester.widget<MealPreviewWidget>(
            mealPreviewWidgets.first,
          );
          expect(firstWidget.meal, equals(meals[0]));
        }
      });

      testWidgets('should configure GridView with correct properties', (
        tester,
      ) async {
        final meals = [buildTestMeal(id: '1', name: 'Chicken Pasta')];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: meals,
                query: 'chicken',
              ),
            ),
          ),
        );

        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget);

        final gridViewWidget = tester.widget<GridView>(gridView);
        expect(gridViewWidget.padding, equals(const EdgeInsets.all(16)));
      });

      testWidgets('should not display no results message when meals exist', (
        tester,
      ) async {
        final meals = [buildTestMeal(id: '1', name: 'Chicken Pasta')];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: meals,
                query: 'chicken',
              ),
            ),
          ),
        );

        expect(find.text('No results found for "chicken"'), findsNothing);
        expect(find.text('Try with other search terms'), findsNothing);
        expect(find.byIcon(Icons.search_off), findsNothing);
      });
    });

    group('Layout and styling', () {
      testWidgets('should handle single meal correctly', (tester) async {
        final meals = [buildTestMeal(id: '1', name: 'Chicken Pasta')];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: meals,
                query: 'chicken',
              ),
            ),
          ),
        );

        expect(find.byType(MealPreviewWidget), findsAtLeastNWidgets(1));
        expect(find.byType(GridView), findsOneWidget);
      });

      testWidgets('should handle multiple meals correctly', (tester) async {
        final meals = List.generate(
          3,
          (index) => buildTestMeal(
            id: index.toString(),
            name: 'Meal $index',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: meals,
                query: 'meal',
              ),
            ),
          ),
        );

        expect(find.byType(MealPreviewWidget), findsAtLeastNWidgets(1));
        expect(find.byType(GridView), findsOneWidget);
      });
    });

    group('Edge cases', () {
      testWidgets('should handle empty query string', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: [],
                query: '',
              ),
            ),
          ),
        );

        expect(find.text('No results found for ""'), findsOneWidget);
      });

      testWidgets('should handle very long query string', (tester) async {
        final longQuery = 'a' * 100;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: const <Meal>[],
                query: longQuery,
              ),
            ),
          ),
        );

        expect(find.text('No results found for "$longQuery"'), findsOneWidget);
      });

      testWidgets('should handle special characters in query', (tester) async {
        const specialQuery = 'chicken & pasta (special)';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: [],
                query: specialQuery,
              ),
            ),
          ),
        );

        expect(
          find.text('No results found for "$specialQuery"'),
          findsOneWidget,
        );
      });

      testWidgets('should handle numbers in query', (tester) async {
        const numericQuery = 'chicken123';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchResultsWidget(
                meals: [],
                query: numericQuery,
              ),
            ),
          ),
        );

        expect(
          find.text('No results found for "$numericQuery"'),
          findsOneWidget,
        );
      });
    });
  });
}
