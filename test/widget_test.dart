// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/main.dart';

void main() {
  testWidgets('Main page navigation test', (WidgetTester tester) async {
    // Initialize dependencies before running the test
    await initDependencies();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts with the first tab (Recipes) selected
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);

    // Verify that the first tab is initially selected (index 0)
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(tester.widget<BottomNavigationBar>(bottomNavBar).currentIndex, equals(0));

    // Tap on the Search tab (index 1)
    await tester.tap(find.text('Search'));
    await tester.pump();

    // Verify that the Search tab is now selected
    expect(tester.widget<BottomNavigationBar>(bottomNavBar).currentIndex, equals(1));

    // Tap on the Favorites tab (index 2)
    await tester.tap(find.text('Favorites'));
    await tester.pump();

    // Verify that the Favorites tab is now selected
    expect(tester.widget<BottomNavigationBar>(bottomNavBar).currentIndex, equals(2));

    // Tap back on the Recipes tab (index 0)
    await tester.tap(find.text('Recipes'));
    await tester.pump();

    // Verify that the Recipes tab is selected again
    expect(tester.widget<BottomNavigationBar>(bottomNavBar).currentIndex, equals(0));
  });
}
