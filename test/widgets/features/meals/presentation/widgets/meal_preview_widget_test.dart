import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_image_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_preview_widget.dart';

void main() {
  group('MealPreviewWidget', () {
    late Meal testMeal;
    late Meal favoriteMeal;

    setUp(() {
      testMeal = const Meal(
        id: '1',
        name: 'Test Meal',
        thumbnail: 'https://example.com/test.jpg',
        category: 'Test Category',
        instructions: 'Test instructions for the meal',
        ingredients: {'ingredient1': 'amount1', 'ingredient2': 'amount2'},
      );

      favoriteMeal = const Meal(
        id: '2',
        name: 'Favorite Meal',
        thumbnail: 'https://example.com/favorite.jpg',
        category: 'Favorite Category',
        instructions: 'Favorite meal instructions',
        ingredients: {'ingredient1': 'amount1'},
        isFavorite: true,
      );
    });

    Widget createTestWidget({required Meal meal}) {
      return MaterialApp(
        home: Scaffold(
          body: MealPreviewWidget(meal: meal),
        ),
      );
    }

    testWidgets('should display meal information correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.text('Test Meal'), findsOneWidget);
      expect(find.text('Category: Test Category'), findsOneWidget);
      expect(find.text('Test instructions for the meal'), findsOneWidget);
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

    testWidgets('should display favorite icon correctly when meal is not favorite', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      final favoriteIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite),
      );
      final favoriteBorderIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite_border),
      );

      expect(favoriteIcon.color, Colors.white);
      expect(favoriteBorderIcon.color, Colors.black);
    });

    testWidgets('should display favorite icon correctly when meal is favorite', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: favoriteMeal));

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      final favoriteIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite),
      );
      final favoriteBorderIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite_border),
      );

      expect(favoriteIcon.color, Colors.red);
      expect(favoriteBorderIcon.color, Colors.white);
    });

    testWidgets('should have correct card styling', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.byType(Card), findsOneWidget);

      final card = tester.widget<Card>(
        find.byType(Card),
      );

      expect(card.elevation, 0);
      expect(card.shape, isA<RoundedRectangleBorder>());

      final shape = card.shape! as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(8));
      expect(shape.side.color, const Color(0xFF68B684));
      expect(shape.side.width, 2);
    });

    testWidgets('should have correct text styling for meal name', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final nameText = tester.widget<Text>(
        find.text('Test Meal'),
      );

      expect(nameText.style?.fontSize, 16);
      expect(nameText.style?.fontWeight, FontWeight.bold);
      expect(nameText.maxLines, 2);
      expect(nameText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should have correct text styling for category', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final categoryText = tester.widget<Text>(
        find.text('Category: Test Category'),
      );

      expect(categoryText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should have correct text styling for instructions', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final instructionsText = tester.widget<Text>(
        find.text('Test instructions for the meal'),
      );

      expect(instructionsText.maxLines, 4);
      expect(instructionsText.overflow, TextOverflow.fade);
      expect(instructionsText.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.byType(Column), findsAtLeastNWidgets(2));
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should handle empty meal data gracefully', (tester) async {
      const emptyMeal = Meal.empty();

      await tester.pumpWidget(createTestWidget(meal: emptyMeal));

      expect(find.text(''), findsAtLeastNWidgets(1));
      expect(find.byType(MealImageWidget), findsOneWidget);
    });

    testWidgets('should have correct padding and spacing', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final paddingWidgets = find.byType(Padding);
      expect(paddingWidgets, findsAtLeastNWidgets(1));

      // Verificar que hay SizedBox para espaciado
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsAtLeastNWidgets(1));
    });

    testWidgets('should have correct favorite icon positioning', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final positionedWidget = tester.widget<Positioned>(
        find.byType(Positioned),
      );

      expect(positionedWidget.child, isA<Align>());

      final alignWidget = positionedWidget.child as Align;
      expect(alignWidget.alignment, Alignment.topRight);
    });

    testWidgets('should have correct favorite icon size', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final favoriteIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite),
      );
      final favoriteBorderIcon = tester.widget<Icon>(
        find.byIcon(Icons.favorite_border),
      );

      expect(favoriteIcon.size, 30);
      expect(favoriteBorderIcon.size, 30);
    });

    testWidgets('should handle long meal names with ellipsis', (tester) async {
      const longNameMeal = Meal(
        id: '3',
        name:
            'This is a very long meal name that should be truncated with ellipsis when it exceeds the maximum number of lines',
        thumbnail: 'https://example.com/long.jpg',
        category: 'Long Category',
        instructions: 'Long instructions',
        ingredients: {'ingredient1': 'amount1'},
      );

      await tester.pumpWidget(createTestWidget(meal: longNameMeal));

      final nameText = tester.widget<Text>(
        find.textContaining('This is a very long meal name'),
      );

      expect(nameText.maxLines, 2);
      expect(nameText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should handle long instructions with fade overflow', (tester) async {
      const longInstructionsMeal = Meal(
        id: '4',
        name: 'Long Instructions Meal',
        thumbnail: 'https://example.com/long.jpg',
        category: 'Long Category',
        instructions:
            'This is a very long instruction text that should be handled with fade overflow when it exceeds the maximum number of lines allowed in the widget',
        ingredients: {'ingredient1': 'amount1'},
      );

      await tester.pumpWidget(createTestWidget(meal: longInstructionsMeal));

      final instructionsText = tester.widget<Text>(
        find.textContaining('This is a very long instruction text'),
      );

      expect(instructionsText.maxLines, 4);
      expect(instructionsText.overflow, TextOverflow.fade);
    });

    testWidgets('should have correct gesture detector setup', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.byType(GestureDetector), findsOneWidget);

      // Verificar que el GestureDetector envuelve todo el contenido
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );

      expect(gestureDetector.onTap, isNotNull);
    });
  });
}
