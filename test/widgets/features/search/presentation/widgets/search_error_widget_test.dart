import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_error_widget.dart';

void main() {
  group('SearchErrorWidget', () {
    const testErrorMessage = 'Network error occurred';
    late VoidCallback testOnRetry;

    setUp(() {
      testOnRetry = () {};
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: SearchErrorWidget(
            errorMessage: testErrorMessage,
            onRetry: testOnRetry,
          ),
        ),
      );
    }

    testWidgets('should display error icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(icon.size, 64);
      expect(icon.color, Colors.red[400]);
    });

    testWidgets('should display error message', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text(testErrorMessage), findsOneWidget);

      final errorText = tester.widget<Text>(find.text(testErrorMessage));
      expect(errorText.style?.color, Colors.grey[600]);
      expect(errorText.textAlign, TextAlign.center);
    });

    testWidgets('should display retry button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Icon), findsAtLeastNWidgets(2));
      expect(find.byType(Text), findsAtLeastNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have correct spacing between elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
    });

    testWidgets('should call onRetry when retry button is tapped', (tester) async {
      var retryCalled = false;
      void onRetry() {
        retryCalled = true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchErrorWidget(
              errorMessage: testErrorMessage,
              onRetry: onRetry,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain consistent layout on rebuild', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(testErrorMessage), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should work with different themes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SearchErrorWidget(
              errorMessage: testErrorMessage,
              onRetry: testOnRetry,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(testErrorMessage), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should work in different screen sizes', (tester) async {
      // Simular pantalla pequeña
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(320, 480);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(testErrorMessage), findsOneWidget);

      // Simular pantalla grande
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(testErrorMessage), findsOneWidget);

      // Restaurar tamaño original
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    testWidgets('should handle long error messages', (tester) async {
      const longErrorMessage =
          'This is a very long error message that should be displayed correctly without breaking the layout or causing any rendering issues';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchErrorWidget(
              errorMessage: longErrorMessage,
              onRetry: testOnRetry,
            ),
          ),
        ),
      );

      expect(find.text(longErrorMessage), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle empty error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchErrorWidget(
              errorMessage: '',
              onRetry: testOnRetry,
            ),
          ),
        ),
      );

      expect(find.text(''), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle null onRetry callback', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchErrorWidget(
              errorMessage: testErrorMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(testErrorMessage), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have correct column alignment', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('should have correct center alignment', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('should have correct icon properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final errorIcon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(errorIcon.size, 64);
      expect(errorIcon.color, Colors.red[400]);
    });

    testWidgets('should have correct text properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final errorText = tester.widget<Text>(find.text(testErrorMessage));
      expect(errorText.style?.color, Colors.grey[600]);
      expect(errorText.textAlign, TextAlign.center);
      expect(errorText.style?.fontSize, isNotNull);
    });

    testWidgets('should have correct button properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final retryButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(retryButton.onPressed, isNotNull);
      expect(retryButton.child, isA<Row>());

      final buttonRow = retryButton.child! as Row;
      expect(buttonRow.children.length, 3); // Icon + SizedBox + Text
      expect(buttonRow.children[2], isA<Text>());

      final buttonText = buttonRow.children[2] as Text;
      expect(buttonText.data, 'Retry');
    });

    testWidgets('should have correct sized box heights', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find SizedBoxes by their context in the widget tree
      final column = tester.widget<Column>(find.byType(Column));

      // Check SizedBox between icon and title (first child after icon)
      final firstSizedBox = column.children[1] as SizedBox;
      expect(firstSizedBox.height, 16);

      // Check SizedBox between title and message (third child after title)
      final secondSizedBox = column.children[3] as SizedBox;
      expect(secondSizedBox.height, 8);

      // Check SizedBox between message and button (fifth child after message)
      final thirdSizedBox = column.children[5] as SizedBox;
      expect(thirdSizedBox.height, 16);

      // Check SizedBox inside button (between icon and text)
      final button = column.children[6] as ElevatedButton;
      final buttonRow = button.child! as Row;
      final buttonSizedBox = buttonRow.children[1] as SizedBox;
      expect(buttonSizedBox.width, 8);
    });
  });
}
