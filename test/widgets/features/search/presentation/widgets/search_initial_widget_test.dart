import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/search/presentation/widgets/search_initial_widget.dart';

void main() {
  group('SearchInitialWidget', () {
    group('Rendering', () {
      testWidgets('should display search icon', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('should display main title', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.text('Search your favorite recipes'), findsOneWidget);
      });

      testWidgets('should display subtitle', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(
          find.text('Write the name of a food to find delicious recipes'),
          findsOneWidget,
        );
      });

      testWidgets('should display search examples section', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.text('Search examples:'), findsOneWidget);
      });

      testWidgets('should display all example chips', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.text('Chicken'), findsOneWidget);
        expect(find.text('Pasta'), findsOneWidget);
        expect(find.text('Salad'), findsOneWidget);
        expect(find.text('Beef'), findsOneWidget);
      });

      testWidgets('should display restaurant icons for examples', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byIcon(Icons.restaurant), findsNWidgets(4));
      });
    });

    group('Icon Properties', () {
      testWidgets('should have correct search icon properties', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search));
        expect(searchIcon.size, equals(64));
        expect(searchIcon.color, equals(Colors.grey[400]));
      });

      testWidgets('should have correct restaurant icon properties', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final restaurantIcons = find.byIcon(Icons.restaurant);
        expect(restaurantIcons, findsNWidgets(4));

        for (var i = 0; i < restaurantIcons.evaluate().length; i++) {
          final icon = tester.widget<Icon>(restaurantIcons.at(i));
          expect(icon.size, equals(16));
          expect(icon.color, equals(Colors.grey[600]));
        }
      });
    });

    group('Text Properties', () {
      testWidgets('should have correct title text style', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final titleText = tester.widget<Text>(
          find.text('Search your favorite recipes'),
        );
        expect(titleText.style?.color, equals(Colors.grey[600]));
        expect(titleText.textAlign, equals(TextAlign.center));
      });

      testWidgets('should have correct subtitle text style', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final subtitleText = tester.widget<Text>(
          find.text('Write the name of a food to find delicious recipes'),
        );
        expect(subtitleText.style?.color, equals(Colors.grey[500]));
        expect(subtitleText.textAlign, equals(TextAlign.center));
      });

      testWidgets('should have correct examples title style', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final examplesTitle = tester.widget<Text>(
          find.text('Search examples:'),
        );
        expect(examplesTitle.style?.color, equals(Colors.grey[700]));
        expect(examplesTitle.style?.fontWeight, equals(FontWeight.bold));
      });

      testWidgets('should have correct example text style', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final chickenText = tester.widget<Text>(find.text('Chicken'));
        expect(chickenText.style?.color, equals(Colors.grey[600]));
      });
    });

    group('Layout and Styling', () {
      testWidgets('should center content', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byType(Center), findsAtLeastNWidgets(1));
      });

      testWidgets('should use column layout', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('should have proper spacing between elements', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsAtLeastNWidgets(3));
      });

      testWidgets('should have correct container decoration', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container).last,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, equals(Colors.grey[100]));
        expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
      });

      testWidgets('should have correct container padding and margin', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.byType(Container).last,
        );
        expect(container.padding, equals(const EdgeInsets.all(16)));
        expect(container.margin, equals(const EdgeInsets.symmetric(horizontal: 32)));
      });
    });

    group('Accessibility', () {
      testWidgets('should have semantic labels', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byType(SearchInitialWidget), findsOneWidget);
        expect(find.byType(Icon), findsNWidgets(5)); // 1 search + 4 restaurant
        expect(find.byType(Text), findsAtLeastNWidgets(6));
      });

      testWidgets('should render without errors', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('should maintain consistent layout on rebuild', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

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

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.text('Search your favorite recipes'), findsOneWidget);

        // Simular pantalla grande
        tester.binding.platformDispatcher.views.first.physicalSize = const Size(1024, 768);
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SearchInitialWidget(),
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.text('Search your favorite recipes'), findsOneWidget);

        // Restaurar tamaño original
        tester.binding.platformDispatcher.views.first.physicalSize = const Size(800, 600);
        tester.binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
      });
    });
  });
}
