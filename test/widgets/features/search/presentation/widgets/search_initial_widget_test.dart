import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_initial_widget.dart';

void main() {
  group('SearchInitialWidget', () {
    Widget createTestWidget() {
      return const MaterialApp(
        home: Scaffold(
          body: SearchInitialWidget(),
        ),
      );
    }

    testWidgets('should display search icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.search), findsOneWidget);

      final icon = tester.widget<Icon>(find.byIcon(Icons.search));
      expect(icon.size, 64);
      expect(icon.color, Colors.grey[400]);
    });

    testWidgets('should display main title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Search your favorite recipes'), findsOneWidget);

      final titleText = tester.widget<Text>(
        find.text('Search your favorite recipes'),
      );
      expect(titleText.style?.color, Colors.grey[600]);
      expect(titleText.textAlign, TextAlign.center);
    });

    testWidgets('should display subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        find.text('Write the name of a food to find delicious recipes'),
        findsOneWidget,
      );

      final subtitleText = tester.widget<Text>(
        find.text('Write the name of a food to find delicious recipes'),
      );
      expect(subtitleText.style?.color, Colors.grey[500]);
      expect(subtitleText.textAlign, TextAlign.center);
    });

    testWidgets('should display search examples section', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Search examples:'), findsOneWidget);

      final examplesTitle = tester.widget<Text>(
        find.text('Search examples:'),
      );
      expect(examplesTitle.style?.color, Colors.grey[700]);
      expect(examplesTitle.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should display all example chips', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Chicken'), findsOneWidget);
      expect(find.text('Pasta'), findsOneWidget);
      expect(find.text('Salad'), findsOneWidget);
      expect(find.text('Beef'), findsOneWidget);
    });

    testWidgets('should display restaurant icons for examples', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.restaurant), findsNWidgets(4));

      final restaurantIcons = find.byIcon(Icons.restaurant);
      for (var i = 0; i < restaurantIcons.evaluate().length; i++) {
        final icon = tester.widget<Icon>(restaurantIcons.at(i));
        expect(icon.size, 16);
        expect(icon.color, Colors.grey[600]);
      }
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should have correct spacing between elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify that SizedBox widgets exist for spacing
      expect(find.byType(SizedBox), findsAtLeastNWidgets(3));
    });

    testWidgets('should have correct padding for examples section', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final examplesContainer = tester.widget<Container>(
        find.byType(Container).last,
      );

      expect(examplesContainer.padding, const EdgeInsets.all(16));
      expect(examplesContainer.margin, const EdgeInsets.symmetric(horizontal: 32));
    });

    testWidgets('should have correct decoration for examples section', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final examplesContainer = tester.widget<Container>(
        find.byType(Container).last,
      );

      final decoration = examplesContainer.decoration! as BoxDecoration;
      expect(decoration.color, Colors.grey[100]);
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify that no errors occurred during rendering
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain consistent layout on rebuild', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Rebuild the widget
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search your favorite recipes'), findsOneWidget);
      expect(find.text('Chicken'), findsOneWidget);
    });

    testWidgets('should work with different themes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: SearchInitialWidget(),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search your favorite recipes'), findsOneWidget);
      expect(find.text('Chicken'), findsOneWidget);
    });

    testWidgets('should work in different screen sizes', (tester) async {
      // Simular pantalla pequeña
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(320, 480);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search your favorite recipes'), findsOneWidget);

      // Simular pantalla grande
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search your favorite recipes'), findsOneWidget);

      // Restaurar tamaño original
      tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
      tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
    });

    testWidgets('should have correct text styles', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final titleText = tester.widget<Text>(
        find.text('Search your favorite recipes'),
      );
      expect(titleText.style?.fontSize, isNotNull);

      final subtitleText = tester.widget<Text>(
        find.text('Write the name of a food to find delicious recipes'),
      );
      expect(subtitleText.style?.fontSize, isNotNull);

      final examplesTitle = tester.widget<Text>(
        find.text('Search examples:'),
      );
      expect(examplesTitle.style?.fontSize, isNotNull);
    });

    testWidgets('should have correct icon properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search));
      expect(searchIcon.size, 64);
      expect(searchIcon.color, Colors.grey[400]);

      final restaurantIcons = find.byIcon(Icons.restaurant);
      for (var i = 0; i < restaurantIcons.evaluate().length; i++) {
        final icon = tester.widget<Icon>(restaurantIcons.at(i));
        expect(icon.size, 16);
        expect(icon.color, Colors.grey[600]);
      }
    });

    testWidgets('should have correct container properties', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final examplesContainer = tester.widget<Container>(
        find.byType(Container).last,
      );

      expect(examplesContainer.padding, const EdgeInsets.all(16));
      expect(examplesContainer.margin, const EdgeInsets.symmetric(horizontal: 32));

      final decoration = examplesContainer.decoration! as BoxDecoration;
      expect(decoration.color, Colors.grey[100]);
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });
  });
}
