import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/custom_app_bar_widget.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';
import 'package:recipe_book/features/search/presentation/pages/search_page.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_error_widget.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_initial_widget.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_loading_widget.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_results_widget.dart';

import 'search_page_test.mocks.dart';

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

@GenerateMocks([SearchBloc])
void main() {
  group('SearchPage', () {
    late MockSearchBloc mockSearchBloc;

    setUp(() {
      mockSearchBloc = MockSearchBloc();
      // Configurar el stream para que emita el estado inicial
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(const SearchState.initial()));
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: SearchPageTestable(
          searchBloc: mockSearchBloc,
        ),
      );
    }

    testWidgets('should display search page with initial state', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SearchPageTestable), findsOneWidget);
      expect(find.byType(CustomAppBarWidget), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(SearchInitialWidget), findsOneWidget);
    });

    testWidgets('should display search bar with correct properties', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.controller, isNotNull);
      expect(textField.autofocus, isTrue);
      expect(textField.decoration?.hintText, 'Ex: chicken, pasta, salad');
      expect(textField.decoration?.prefixIcon, isNotNull);
    });

    testWidgets('should show clear button when text is entered', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Now clear button should be visible
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should clear search when clear button is tapped', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter text
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Verify that SearchCleared event was added
      verify(mockSearchBloc.add(const SearchCleared())).called(1);
    });

    testWidgets('should add SearchQueryChanged event when text changes', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter text
      await tester.enterText(find.byType(TextField), 'chicken');

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Verify that SearchQueryChanged event was added
      verify(mockSearchBloc.add(const SearchQueryChanged('chicken'))).called(1);
    });

    testWidgets('should display loading state', (tester) async {
      when(mockSearchBloc.state).thenReturn(
        const SearchState(status: SearchStatus.loading, query: 'chicken'),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SearchLoadingWidget), findsOneWidget);
      expect(find.byType(SearchInitialWidget), findsNothing);
      expect(find.byType(SearchResultsWidget), findsNothing);
      expect(find.byType(SearchErrorWidget), findsNothing);
    });

    testWidgets('should display success state with results', (tester) async {
      final testMeals = [
        buildTestMeal(id: '1', name: 'Chicken Pasta'),
        buildTestMeal(id: '2', name: 'Chicken Salad'),
      ];

      when(mockSearchBloc.state).thenReturn(
        SearchState(
          status: SearchStatus.success,
          meals: testMeals,
          query: 'chicken',
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SearchResultsWidget), findsOneWidget);
      expect(find.byType(SearchInitialWidget), findsNothing);
      expect(find.byType(SearchLoadingWidget), findsNothing);
      expect(find.byType(SearchErrorWidget), findsNothing);
    });

    testWidgets('should display error state', (tester) async {
      when(mockSearchBloc.state).thenReturn(
        const SearchState(
          status: SearchStatus.failure,
          query: 'chicken',
          errorMessage: 'Failed to search',
        ),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SearchErrorWidget), findsOneWidget);
      expect(find.byType(SearchInitialWidget), findsNothing);
      expect(find.byType(SearchLoadingWidget), findsNothing);
      expect(find.byType(SearchResultsWidget), findsNothing);

      // Debug: Check what's inside SearchErrorWidget
    });

    testWidgets('should retry search when error retry button is tapped', (tester) async {
      when(mockSearchBloc.state).thenReturn(
        const SearchState(
          status: SearchStatus.failure,
          query: 'chicken',
          errorMessage: 'Failed to search',
        ),
      );

      await tester.pumpWidget(createTestWidget());

      // Debug: Check what widgets are actually being rendered

      // Find and tap retry button (ElevatedButton.icon is a subclass of ElevatedButton)
      final retryButton = find.byType(GestureDetector);
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      await tester.pump();

      // Verify that SearchQueryChanged event was added again
      verify(mockSearchBloc.add(const SearchQueryChanged('chicken'))).called(1);
    });

    testWidgets('should handle debounced search correctly', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Type quickly
      await tester.enterText(find.byType(TextField), 'c');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'ch');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'chi');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'chic');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'chick');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'chicke');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Should only call add once with the final query
      verify(mockSearchBloc.add(const SearchQueryChanged('chicken'))).called(1);
    });

    testWidgets('should handle empty search query', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter some text first
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Now clear the text
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Should call add for both queries
      verify(mockSearchBloc.add(const SearchQueryChanged('chicken'))).called(1);
      verify(mockSearchBloc.add(const SearchQueryChanged(''))).called(1);
    });

    testWidgets('should handle whitespace-only search query', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter whitespace-only text
      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Should call add for whitespace-only query, but SearchBloc will filter it
      verify(mockSearchBloc.add(const SearchQueryChanged('   '))).called(1);
    });

    testWidgets('should handle short search query', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter short text
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Should call add for short query
      verify(mockSearchBloc.add(const SearchQueryChanged('a'))).called(1);
    });

    testWidgets('should handle special characters in search query', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter text with special characters
      await tester.enterText(find.byType(TextField), 'chicken & pasta');
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Should call add with special characters
      verify(mockSearchBloc.add(const SearchQueryChanged('chicken & pasta'))).called(1);
    });

    testWidgets('should handle numbers in search query', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter text with numbers
      await tester.enterText(find.byType(TextField), 'chicken123');
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Should call add with numbers
      verify(mockSearchBloc.add(const SearchQueryChanged('chicken123'))).called(1);
    });

    testWidgets('should handle very long search query', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter very long text
      final longQuery = 'a' * 1000;
      await tester.enterText(find.byType(TextField), longQuery);
      await tester.pump();

      // Wait for debounce timer
      await tester.pump(const Duration(milliseconds: 600));

      // Should call add with long query
      verify(mockSearchBloc.add(SearchQueryChanged(longQuery))).called(1);
    });

    testWidgets('should maintain search query in text field across state changes', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter text
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Change state to loading
      when(mockSearchBloc.state).thenReturn(
        const SearchState(status: SearchStatus.loading, query: 'chicken'),
      );
      await tester.pump();

      // Text should still be in the field
      expect(find.text('chicken'), findsOneWidget);
    });

    testWidgets('should dispose resources correctly', (tester) async {
      when(mockSearchBloc.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(createTestWidget());

      // Enter some text
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Dispose the widget
      await tester.pumpWidget(Container());

      // Verify that the bloc was not closed (it's managed externally)
      verifyNever(mockSearchBloc.close());
    });

    testWidgets('SearchErrorWidget should render correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchErrorWidget(
              errorMessage: 'Test error message',
              onRetry: () {},
            ),
          ),
        ),
      );

      // Debug: Check what's being rendered

      // Let's see what text is actually being rendered
      final textWidgets = find.byType(Text).evaluate();
      for (var i = 0; i < textWidgets.length; i++) {
        tester.widget<Text>(find.byType(Text).at(i));
      }

      // Let's see what other widgets are being rendered

      expect(find.byType(SearchErrorWidget), findsOneWidget);
      expect(find.text('Search Error'), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
