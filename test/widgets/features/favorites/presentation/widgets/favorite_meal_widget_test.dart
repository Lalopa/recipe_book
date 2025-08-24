import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_meal_widget.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_image_widget.dart';

import 'favorite_meal_widget_test.mocks.dart';

@GenerateMocks([FavoriteBloc])
void main() {
  group('FavoriteMealWidget', () {
    late MockFavoriteBloc mockFavoriteBloc;

    setUp(() {
      mockFavoriteBloc = MockFavoriteBloc();
      when(mockFavoriteBloc.state).thenReturn(const FavoriteState.initial());
      when(mockFavoriteBloc.stream).thenAnswer((_) => Stream.value(const FavoriteState.initial()));
      when(mockFavoriteBloc.add(any)).thenReturn(null);
    });

    const testMeal = Meal(
      id: 'test-meal-id',
      name: 'Test Favorite Meal',
      thumbnail: 'https://example.com/test-meal.jpg',
      category: 'Test Category',
      instructions: 'These are the test instructions for the meal',
      ingredients: {'ingredient1': 'amount1', 'ingredient2': 'amount2'},
    );

    Widget createTestWidget({
      required Meal meal,
      Map<String, bool>? favoriteStatuses,
    }) {
      final state = FavoriteState(
        status: FavoriteStatus.success,
        favoriteMeals: [meal],
        isLoading: false,
        favoriteStatuses: favoriteStatuses ?? {meal.id: true},
      );

      when(mockFavoriteBloc.state).thenReturn(state);
      when(mockFavoriteBloc.stream).thenAnswer((_) => Stream.value(state));

      return MaterialApp(
        home: BlocProvider<FavoriteBloc>.value(
          value: mockFavoriteBloc,
          child: Scaffold(
            body: FavoriteMealWidget(meal: meal),
          ),
        ),
      );
    }

    group('UI Display', () {
      testWidgets('should display meal information correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(meal: testMeal));

        expect(find.text('Test Favorite Meal'), findsOneWidget);
        expect(find.text('Category: Test Category'), findsOneWidget);
        expect(find.text('These are the test instructions for the meal'), findsOneWidget);
      });

      testWidgets('should display MealImageWidget with correct parameters', (tester) async {
        await tester.pumpWidget(createTestWidget(meal: testMeal));

        expect(find.byType(MealImageWidget), findsOneWidget);

        final mealImageWidget = tester.widget<MealImageWidget>(
          find.byType(MealImageWidget),
        );

        expect(mealImageWidget.imageUrl, testMeal.thumbnail);
        expect(mealImageWidget.height, 120);
      });

      testWidgets('should display FavoriteButtonWidget', (tester) async {
        await tester.pumpWidget(createTestWidget(meal: testMeal));

        expect(find.byType(FavoriteButtonWidget), findsOneWidget);

        final favoriteButton = tester.widget<FavoriteButtonWidget>(
          find.byType(FavoriteButtonWidget),
        );

        expect(favoriteButton.mealId, testMeal.id);
        expect(favoriteButton.isFavorite, true);
        expect(favoriteButton.size, 20);
      });

      testWidgets('should display card with correct styling', (tester) async {
        await tester.pumpWidget(createTestWidget(meal: testMeal));

        expect(find.byType(Card), findsOneWidget);

        final card = tester.widget<Card>(find.byType(Card));
        final shape = card.shape! as RoundedRectangleBorder;

        expect(card.elevation, 0);
        expect(shape.borderRadius, BorderRadius.circular(8));
        expect(shape.side.color, const Color(0xFF68B684));
        expect(shape.side.width, 2);
      });

      testWidgets('should handle long meal names with ellipsis', (tester) async {
        const longMeal = Meal(
          id: 'long-meal-id',
          name: 'This is a very long meal name that should be truncated with ellipsis',
          thumbnail: 'https://example.com/long-meal.jpg',
          category: 'Long Category',
          instructions: 'Long instructions',
          ingredients: {'ingredient': 'amount'},
        );

        await tester.pumpWidget(createTestWidget(meal: longMeal));

        final mealNameText = tester.widget<Text>(
          find.text(longMeal.name),
        );

        expect(mealNameText.maxLines, 2);
        expect(mealNameText.overflow, TextOverflow.ellipsis);
      });

      testWidgets('should handle long instructions with fade overflow', (tester) async {
        const longInstructionsMeal = Meal(
          id: 'long-instructions-meal',
          name: 'Test Meal',
          thumbnail: 'https://example.com/test.jpg',
          category: 'Test Category',
          instructions:
              'These are very long instructions that should fade out when they exceed the maximum number of lines allowed for display in the widget',
          ingredients: {'ingredient': 'amount'},
        );

        await tester.pumpWidget(createTestWidget(meal: longInstructionsMeal));

        final instructionsText = tester.widget<Text>(
          find.text(longInstructionsMeal.instructions),
        );

        expect(instructionsText.maxLines, 4);
        expect(instructionsText.overflow, TextOverflow.fade);
      });

      testWidgets('should handle null thumbnail', (tester) async {
        const mealWithoutThumbnail = Meal(
          id: 'no-thumbnail-meal',
          name: 'Meal Without Thumbnail',
          thumbnail: null,
          category: 'No Thumbnail Category',
          instructions: 'Instructions for meal without thumbnail',
          ingredients: {'ingredient': 'amount'},
        );

        await tester.pumpWidget(createTestWidget(meal: mealWithoutThumbnail));

        expect(find.byType(MealImageWidget), findsOneWidget);

        final mealImageWidget = tester.widget<MealImageWidget>(
          find.byType(MealImageWidget),
        );

        expect(mealImageWidget.imageUrl, isNull);
      });
    });

    group('BlocBuilder Integration', () {
      testWidgets('should show favorite button as favorite when meal is in favorites', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            meal: testMeal,
            favoriteStatuses: {testMeal.id: true},
          ),
        );

        final favoriteButton = tester.widget<FavoriteButtonWidget>(
          find.byType(FavoriteButtonWidget),
        );

        expect(favoriteButton.isFavorite, true);
      });

      testWidgets('should show favorite button as not favorite when meal is not in favorites', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            meal: testMeal,
            favoriteStatuses: {testMeal.id: false},
          ),
        );

        final favoriteButton = tester.widget<FavoriteButtonWidget>(
          find.byType(FavoriteButtonWidget),
        );

        expect(favoriteButton.isFavorite, false);
      });

      testWidgets('should default to false when meal status is not in favoriteStatuses', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            meal: testMeal,
            favoriteStatuses: {}, // Empty map
          ),
        );

        final favoriteButton = tester.widget<FavoriteButtonWidget>(
          find.byType(FavoriteButtonWidget),
        );

        expect(favoriteButton.isFavorite, false);
      });
    });

    group('Layout', () {
      testWidgets('should display elements in correct order', (tester) async {
        await tester.pumpWidget(createTestWidget(meal: testMeal));

        expect(find.byType(MealImageWidget), findsOneWidget);
        expect(find.text('Category: Test Category'), findsOneWidget);
        expect(find.text('Test Favorite Meal'), findsOneWidget);
        expect(find.text('These are the test instructions for the meal'), findsOneWidget);
        expect(find.byType(FavoriteButtonWidget), findsOneWidget);
      });

      testWidgets('should position favorite button correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(meal: testMeal));

        final positioned = tester.widget<Positioned>(
          find.byType(Positioned),
        );

        expect(positioned.top, 8);
        expect(positioned.right, 8);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty category', (tester) async {
        const emptyCategory = Meal(
          id: 'empty-category-meal',
          name: 'Test Meal',
          thumbnail: 'https://example.com/test.jpg',
          category: '',
          instructions: 'Test instructions',
          ingredients: {'ingredient': 'amount'},
        );

        await tester.pumpWidget(createTestWidget(meal: emptyCategory));

        expect(find.text('Category: '), findsOneWidget);
      });

      testWidgets('should handle empty instructions', (tester) async {
        const emptyInstructions = Meal(
          id: 'empty-instructions-meal',
          name: 'Test Meal',
          thumbnail: 'https://example.com/test.jpg',
          category: 'Test Category',
          instructions: '',
          ingredients: {'ingredient': 'amount'},
        );

        await tester.pumpWidget(createTestWidget(meal: emptyInstructions));

        expect(find.text(''), findsWidgets);
      });

      testWidgets('should handle empty meal name', (tester) async {
        const emptyName = Meal(
          id: 'empty-name-meal',
          name: '',
          thumbnail: 'https://example.com/test.jpg',
          category: 'Test Category',
          instructions: 'Test instructions',
          ingredients: {'ingredient': 'amount'},
        );

        await tester.pumpWidget(createTestWidget(meal: emptyName));

        expect(find.text(''), findsWidgets);
      });
    });
  });
}
