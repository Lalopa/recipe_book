import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_image_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/random_meal_widget.dart';

void main() {
  group('RandomMealWidget', () {
    late Meal testMeal;

    setUp(() {
      testMeal = const Meal(
        id: '1',
        name: 'Random Test Meal',
        thumbnail: 'https://example.com/random.jpg',
        category: 'Random Category',
        instructions: 'Random meal instructions',
        ingredients: {'ingredient1': 'amount1', 'ingredient2': 'amount2'},
      );
    });

    Widget createTestWidget({required Meal meal}) {
      return MaterialApp(
        home: Scaffold(
          body: RandomMealWidget(meal: meal),
        ),
      );
    }

    testWidgets('should display meal name correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.text('Random Test Meal'), findsOneWidget);
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
        find.text('Random Test Meal'),
      );

      expect(nameText.style?.fontSize, 16);
      expect(nameText.style?.fontWeight, FontWeight.bold);
      expect(nameText.maxLines, 2);
      expect(nameText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should have correct padding for meal name', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      // Buscar el Padding que contiene el texto del nombre de la comida
      final paddingWidgets = find.byType(Padding);
      final paddingWithText = tester.widget<Padding>(
        paddingWidgets.last, // El último Padding contiene el texto
      );

      expect(paddingWithText.padding, const EdgeInsets.all(8));
    });

    testWidgets('should handle empty meal data gracefully', (tester) async {
      const emptyMeal = Meal.empty();

      await tester.pumpWidget(createTestWidget(meal: emptyMeal));

      expect(find.text(''), findsAtLeastNWidgets(1));
      expect(find.byType(MealImageWidget), findsOneWidget);
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

    testWidgets('should handle long meal names with ellipsis', (tester) async {
      const longNameMeal = Meal(
        id: '2',
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

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      // Verificar que no hay errores de renderizado
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain consistent layout on rebuild', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      // Reconstruir el widget
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.text('Random Test Meal'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(MealImageWidget), findsOneWidget);
    });

    testWidgets('should work with different themes', (tester) async {
      // Probar con tema personalizado
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: RandomMealWidget(meal: testMeal),
          ),
        ),
      );

      expect(find.text('Random Test Meal'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should work in different screen sizes', (tester) async {
      // Simular pantalla pequeña
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(320, 480);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.text('Random Test Meal'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);

      // Simular pantalla grande
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      expect(find.text('Random Test Meal'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);

      // Restaurar tamaño original
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    testWidgets('should have correct column alignment', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final column = tester.widget<Column>(
        find.byType(Column),
      );

      expect(column.mainAxisSize, MainAxisSize.min);
    });

    testWidgets('should handle meals with null thumbnail', (tester) async {
      const mealWithNullThumbnail = Meal(
        id: '3',
        name: 'No Thumbnail Meal',
        thumbnail: null,
        category: 'No Thumbnail Category',
        instructions: 'No thumbnail instructions',
        ingredients: {'ingredient1': 'amount1'},
      );

      await tester.pumpWidget(createTestWidget(meal: mealWithNullThumbnail));

      expect(find.text('No Thumbnail Meal'), findsOneWidget);
      expect(find.byType(MealImageWidget), findsOneWidget);
    });

    testWidgets('should handle meals with empty thumbnail', (tester) async {
      const mealWithEmptyThumbnail = Meal(
        id: '4',
        name: 'Empty Thumbnail Meal',
        thumbnail: '',
        category: 'Empty Thumbnail Category',
        instructions: 'Empty thumbnail instructions',
        ingredients: {'ingredient1': 'amount1'},
      );

      await tester.pumpWidget(createTestWidget(meal: mealWithEmptyThumbnail));

      expect(find.text('Empty Thumbnail Meal'), findsOneWidget);
      expect(find.byType(MealImageWidget), findsOneWidget);
    });

    testWidgets('should have correct card child structure', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final card = tester.widget<Card>(
        find.byType(Card),
      );

      expect(card.child, isA<Column>());
    });

    testWidgets('should have correct column children count', (tester) async {
      await tester.pumpWidget(createTestWidget(meal: testMeal));

      final column = tester.widget<Column>(
        find.byType(Column),
      );

      expect(column.children.length, 2); // MealImageWidget + Padding with Text
    });
  });
}
