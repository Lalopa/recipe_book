import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_loading_widget.dart';

void main() {
  group('MealLoadingWidget', () {
    Widget createTestWidget() {
      return const MaterialApp(
        home: Scaffold(
          body: MealLoadingWidget(),
        ),
      );
    }

    testWidgets('should display CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display loading text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should have correct text styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final loadingText = tester.widget<Text>(
        find.text('Loading...'),
      );

      expect(loadingText.style?.fontSize, 16);
      expect(loadingText.style?.color, Colors.grey);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should center content vertically and horizontally', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final center = tester.widget<Center>(
        find.byType(Center),
      );

      expect(center.child, isA<Column>());

      final column = center.child! as Column;
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should have correct spacing between elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox),
      );

      expect(sizedBox.height, 16);
    });

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verificar que no hay errores de renderizado
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain consistent layout on rebuild', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Reconstruir el widget
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should work in different screen sizes', (tester) async {
      // Simular pantalla pequeña
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(320, 480);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);

      // Simular pantalla grande
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);

      // Restaurar tamaño original
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    testWidgets('should handle theme changes correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Cambiar a tema oscuro
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: MealLoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });
  });
}
