import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/meals/presentation/widgets/custom_app_bar_widget.dart';

void main() {
  group('CustomAppBarWidget', () {
    const defaultTitle = 'What Do Yo Want \nTo Cook Today?';
    const customTitle = 'Custom Title';

    Widget createTestWidget({String? title}) {
      return MaterialApp(
        home: Scaffold(
          appBar: CustomAppBarWidget(title: title ?? 'What Do Yo Want \nTo Cook Today?'),
        ),
      );
    }

    testWidgets('should implement PreferredSizeWidget', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final appBar = tester.widget<CustomAppBarWidget>(
        find.byType(CustomAppBarWidget),
      );

      expect(appBar, isA<PreferredSizeWidget>());
    });

    testWidgets('should have correct preferred size', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final appBar = tester.widget<CustomAppBarWidget>(
        find.byType(CustomAppBarWidget),
      );

      expect(appBar.preferredSize, const Size.fromHeight(80));
    });

    testWidgets('should display default title when no title is provided', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text(defaultTitle), findsOneWidget);
    });

    testWidgets('should display custom title when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(title: customTitle));

      expect(find.text(customTitle), findsOneWidget);
      expect(find.text(defaultTitle), findsNothing);
    });

    testWidgets('should have correct AppBar properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final appBar = tester.widget<AppBar>(
        find.byType(AppBar),
      );

      expect(appBar.toolbarHeight, 80);
      expect(appBar.automaticallyImplyLeading, false);
      expect(appBar.surfaceTintColor, Colors.transparent);
      expect(appBar.backgroundColor, Colors.transparent);
      expect(appBar.elevation, 0);
    });

    testWidgets('should have correct title styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final titleText = tester.widget<Text>(
        find.text(defaultTitle),
      );

      expect(titleText.style?.fontSize, 25);
      expect(titleText.style?.fontWeight, FontWeight.w600);
      expect(titleText.style?.color, const Color(0xFF333333));
      expect(titleText.textAlign, TextAlign.start);
    });

    testWidgets('should have correct title container width', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox),
      );

      expect(sizedBox.width, isA<double>());
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

      expect(find.text(defaultTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should work with different themes', (tester) async {
      // Probar con tema personalizado
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            appBar: CustomAppBarWidget(),
          ),
        ),
      );

      expect(find.text(defaultTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should work in different screen sizes', (tester) async {
      // Simular pantalla pequeña
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(320, 480);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget());

      expect(find.text(defaultTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Simular pantalla grande
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
      await tester.pumpWidget(createTestWidget());

      expect(find.text(defaultTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Restaurar tamaño original
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    testWidgets('should handle long titles correctly', (tester) async {
      const longTitle =
          'This is a very long title that should be handled properly by the CustomAppBarWidget without causing any layout issues or overflow problems';

      await tester.pumpWidget(createTestWidget(title: longTitle));

      expect(find.text(longTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should handle empty title gracefully', (tester) async {
      await tester.pumpWidget(createTestWidget(title: ''));

      expect(find.text(''), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should handle null title gracefully', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text(defaultTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should have correct text alignment', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final titleText = tester.widget<Text>(
        find.text(defaultTitle),
      );

      expect(titleText.textAlign, TextAlign.start);
    });

    testWidgets('should have correct AppBar structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should handle multiline titles correctly', (tester) async {
      const multilineTitle = 'Line 1\nLine 2\nLine 3';

      await tester.pumpWidget(createTestWidget(title: multilineTitle));

      expect(find.text(multilineTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should have correct preferred size after theme change', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final appBar = tester.widget<CustomAppBarWidget>(
        find.byType(CustomAppBarWidget),
      );

      expect(appBar.preferredSize, const Size.fromHeight(80));

      // Cambiar tema
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            appBar: CustomAppBarWidget(),
          ),
        ),
      );

      final newAppBar = tester.widget<CustomAppBarWidget>(
        find.byType(CustomAppBarWidget),
      );

      expect(newAppBar.preferredSize, const Size.fromHeight(80));
    });
  });
}
