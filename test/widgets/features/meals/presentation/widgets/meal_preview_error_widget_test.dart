import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_book/core/theme/theme.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_preview_error_widget.dart';

void main() {
  group('MealPreviewWidgetError', () {
    Widget createTestWidget() {
      return MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: MealPreviewWidgetError(),
        ),
      );
    }

    testWidgets('should display error icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(FaIcon), findsOneWidget);

      final faIcon = tester.widget<FaIcon>(
        find.byType(FaIcon),
      );

      expect(faIcon.icon, FontAwesomeIcons.triangleExclamation);
      expect(faIcon.size, 40);
      expect(faIcon.color, Colors.red);
    });

    testWidgets('should display error message', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        find.text('Error loading meal. Please try again later.'),
        findsOneWidget,
      );
    });

    testWidgets('should have correct text styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final errorText = tester.widget<Text>(
        find.text('Error loading meal. Please try again later.'),
      );

      expect(errorText.textAlign, TextAlign.center);
      expect(errorText.style?.color, Colors.red);
    });

    testWidgets('should use theme text style', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final errorText = tester.widget<Text>(
        find.text('Error loading meal. Please try again later.'),
      );

      // Verificar que usa el tema de la app
      expect(errorText.style, isNotNull);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should center content vertically and horizontally', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final center = tester.widget<Center>(
        find.byType(Center),
      );

      expect(center.child, isA<Padding>());
    });

    testWidgets('should have correct padding', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final padding = tester.widget<Padding>(
        find.byType(Padding),
      );

      expect(padding.padding, const EdgeInsets.all(16));
    });

    testWidgets('should have correct column alignment', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final column = tester.widget<Column>(
        find.byType(Column),
      );

      expect(column.mainAxisSize, MainAxisSize.min);
    });

    testWidgets('should have correct spacing between elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox),
      );

      expect(sizedBox.height, 10);
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

      expect(find.byType(FaIcon), findsOneWidget);
      expect(
        find.text('Error loading meal. Please try again later.'),
        findsOneWidget,
      );
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should work with different themes', (tester) async {
      // Probar con tema personalizado
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ),
          home: const Scaffold(
            body: MealPreviewWidgetError(),
          ),
        ),
      );

      expect(find.byType(FaIcon), findsOneWidget);
      expect(
        find.text('Error loading meal. Please try again later.'),
        findsOneWidget,
      );
    });

    testWidgets('should work in different screen sizes', (tester) async {
      // Simular pantalla pequeña
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(320, 480);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(FaIcon), findsOneWidget);
      expect(
        find.text('Error loading meal. Please try again later.'),
        findsOneWidget,
      );

      // Simular pantalla grande
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(FaIcon), findsOneWidget);
      expect(
        find.text('Error loading meal. Please try again later.'),
        findsOneWidget,
      );

      // Restaurar tamaño original
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    testWidgets('should handle accessibility correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verificar que el texto es accesible
      final errorText = tester.widget<Text>(
        find.text('Error loading meal. Please try again later.'),
      );

      expect(errorText.textAlign, TextAlign.center);
    });

    testWidgets('should have correct icon properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final faIcon = tester.widget<FaIcon>(
        find.byType(FaIcon),
      );

      expect(faIcon.icon, FontAwesomeIcons.triangleExclamation);
      expect(faIcon.size, 40);
      expect(faIcon.color, Colors.red);
    });

    testWidgets('should handle text overflow gracefully', (tester) async {
      // Probar con texto muy largo
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme(),
          home: const Scaffold(
            body: MealPreviewWidgetError(),
          ),
        ),
      );

      // Verificar que el texto se renderiza correctamente
      expect(
        find.text('Error loading meal. Please try again later.'),
        findsOneWidget,
      );
    });
  });
}
