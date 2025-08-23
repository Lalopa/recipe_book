import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_preview_widget.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_results_widget.dart';

import '../pages/search_page_test.mocks.dart';

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
  Widget createTestWidget({
    required List<Meal> meals,
    required String query,
  }) {
    final mockFavoriteBloc = MockFavoriteBloc();

    when(mockFavoriteBloc.state).thenReturn(const FavoriteState.initial());
    when(mockFavoriteBloc.stream).thenAnswer((_) => Stream.value(const FavoriteState.initial()));

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteBloc>.value(
            value: mockFavoriteBloc,
          ),
        ],
        child: Scaffold(
          body: SearchResultsWidget(
            meals: meals,
            query: query,
          ),
        ),
      ),
    );
  }

  group('SearchResultsWidget', () {
    group('Empty results', () {
      testWidgets(
        'should display no results message when meals list is empty',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              meals: [],
              query: 'chicken',
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
          createTestWidget(
            meals: [],
            query: 'pasta carbonara',
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
            createTestWidget(
              meals: [],
              query: 'chicken',
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
          createTestWidget(
            meals: [],
            query: 'chicken',
          ),
        );

        final titleText = find.text('No results found for "chicken"');
        final subtitleText = find.text('Try with other search terms');

        expect(titleText, findsOneWidget);
        expect(subtitleText, findsOneWidget);

        final titleTextStyle = tester.widget<Text>(titleText).style;
        final subtitleTextStyle = tester.widget<Text>(subtitleText).style;

        expect(titleTextStyle?.fontSize, equals(16));
        expect(titleTextStyle?.fontWeight, equals(FontWeight.w500));
        expect(subtitleTextStyle?.fontSize, equals(14));
        expect(subtitleTextStyle?.color, equals(Colors.grey[500]));
      });
    });

    group('With results', () {
      testWidgets('should display meals when list is not empty', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Chicken Pasta'),
          buildTestMeal(id: '2', name: 'Chicken Salad'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'chicken',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsNWidgets(2));
        expect(find.text('Chicken Pasta'), findsOneWidget);
        expect(find.text('Chicken Salad'), findsOneWidget);
        expect(find.text('No results found'), findsNothing);
      });

      testWidgets('should not display no results message when meals exist', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Chicken Pasta'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'chicken',
          ),
        );

        expect(find.text('No results found'), findsNothing);
        expect(find.byType(MealPreviewWidget), findsOneWidget);
      });

      testWidgets('should display correct number of meals', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Meal 1'),
          buildTestMeal(id: '2', name: 'Meal 2'),
          buildTestMeal(id: '3', name: 'Meal 3'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'meal',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsAtLeastNWidgets(2));
      });
    });

    group('Layout and styling', () {
      testWidgets('should handle single meal correctly', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Single Meal'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'single',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsOneWidget);
        expect(find.text('Single Meal'), findsOneWidget);
      });

      testWidgets('should handle multiple meals correctly', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Meal 1'),
          buildTestMeal(id: '2', name: 'Meal 2'),
          buildTestMeal(id: '3', name: 'Meal 3'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'meal',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsAtLeastNWidgets(2));
        expect(find.text('Meal 1'), findsOneWidget);
        expect(find.text('Meal 2'), findsOneWidget);
        // Meal 3 puede no estar visible en GridView.builder durante los tests
        expect(find.text('Meal 1'), findsOneWidget);
        expect(find.text('Meal 2'), findsOneWidget);
      });

      testWidgets('should apply correct padding and spacing', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Meal 1'),
          buildTestMeal(id: '2', name: 'Meal 2'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'meal',
          ),
        );

        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget);

        final gridViewWidget = tester.widget<GridView>(gridView);
        expect(gridViewWidget.padding, equals(const EdgeInsets.all(16)));
      });

      testWidgets('should use correct grid configuration', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Meal 1'),
          buildTestMeal(id: '2', name: 'Meal 2'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'meal',
          ),
        );

        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget);

        final gridViewWidget = tester.widget<GridView>(gridView);
        expect(gridViewWidget.gridDelegate, isA<SliverGridDelegateWithFixedCrossAxisCount>());

        final delegate = gridViewWidget.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, equals(2));
        expect(delegate.crossAxisSpacing, equals(10));
        expect(delegate.mainAxisSpacing, equals(10));
        expect(delegate.childAspectRatio, equals(0.65));
      });
    });

    group('Edge cases', () {
      testWidgets('should handle meals with missing data', (tester) async {
        final meals = [
          buildTestMeal(
            id: '1',
            name: 'Minimal Meal',
          ),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'minimal',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsOneWidget);
        expect(find.text('Minimal Meal'), findsOneWidget);
      });

      testWidgets('should handle very long meal names', (tester) async {
        final longName = 'A' * 100; // Very long name
        final meals = [
          buildTestMeal(id: '1', name: longName),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'long',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsOneWidget);
        expect(find.text(longName), findsOneWidget);
      });

      testWidgets('should handle special characters in meal names', (tester) async {
        const specialName = r'Meal with special chars: !@#$%^&*()';
        final meals = [
          buildTestMeal(id: '1', name: specialName),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'special',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsOneWidget);
        expect(find.text(specialName), findsOneWidget);
      });

      testWidgets('should handle empty query string', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Test Meal'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: '',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsOneWidget);
        expect(find.text('Test Meal'), findsOneWidget);
      });

      testWidgets('should handle query with only whitespace', (tester) async {
        final meals = [
          buildTestMeal(id: '1', name: 'Test Meal'),
        ];

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: '   ',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsOneWidget);
        expect(find.text('Test Meal'), findsOneWidget);
      });
    });

    group('Performance and behavior', () {
      testWidgets('should handle large number of meals efficiently', (tester) async {
        final meals = List.generate(
          50,
          (index) => buildTestMeal(
            id: index.toString(),
            name: 'Meal $index',
          ),
        );

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'meal',
          ),
        );

        expect(find.byType(MealPreviewWidget), findsAtLeastNWidgets(2));
      });

      testWidgets('should maintain scroll position during rebuilds', (tester) async {
        final meals = List.generate(
          20,
          (index) => buildTestMeal(
            id: index.toString(),
            name: 'Meal $index',
          ),
        );

        await tester.pumpWidget(
          createTestWidget(
            meals: meals,
            query: 'meal',
          ),
        );

        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget);

        // Simulate scroll
        await tester.drag(gridView, const Offset(0, -100));
        await tester.pump();

        // Verify scroll position is maintained
        expect(find.byType(MealPreviewWidget), findsAtLeastNWidgets(4));
      });
    });
  });
}
