import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_loading_widget.dart';

void main() {
  group('SearchLoadingWidget', () {
    Widget createTestWidget() {
      return const MaterialApp(
        home: Scaffold(
          body: SearchLoadingWidget(),
        ),
      );
    }

    testWidgets('should display loading indicator', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display loading text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Searching...'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should have correct spacing between elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SizedBox), findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 16);
    });

    testWidgets('should have correct text styling', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final loadingText = tester.widget<Text>(find.text('Searching...'));
      expect(loadingText.style?.color, Colors.grey);
      expect(loadingText.style?.fontSize, 16);
    });

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain consistent layout on rebuild', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Searching...'), findsOneWidget);
    });

    testWidgets('should work with different themes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: SearchLoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Searching...'), findsOneWidget);
    });

    testWidgets('should work in different screen sizes', (tester) async {
      // Simular pantalla pequeña
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(320, 480);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Searching...'), findsOneWidget);

      // Simular pantalla grande
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Searching...'), findsOneWidget);

      // Restaurar tamaño original
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    testWidgets('should have correct column alignment', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('should have correct center alignment', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final center = tester.widget<Center>(find.byType(Center));
      expect(center.child, isA<Column>());
    });

    testWidgets('should have correct sized box height', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 16);
    });

    testWidgets('should have correct text properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final loadingText = tester.widget<Text>(find.text('Searching...'));
      expect(loadingText.style?.color, Colors.grey);
      expect(loadingText.style?.fontSize, 16);
    });

    testWidgets('should have correct circular progress indicator', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator, isNotNull);
    });
  });
}
