// This is a comprehensive test for the meals feature using mocks
//
// This test covers different scenarios:
// - Empty list response
// - List with data response
// - Loading state
// - Error handling

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:recipe_book/features/meals/presentation/pages/meals_page.dart';

// Generate mocks
@GenerateMocks([MealRepository])
import 'widget_test.mocks.dart';

void main() {
  group('MealsPage Tests', () {
    late MockMealRepository mockMealRepository;
    late GetMealsByLetter getMealsByLetter;
    late MealBloc mealBloc;

    setUp(() {
      mockMealRepository = MockMealRepository();
      getMealsByLetter = GetMealsByLetter(mockMealRepository);
      mealBloc = MealBloc(getMealsByLetter);
    });

    tearDown(() {
      mealBloc.close();
    });

    testWidgets('should show loading state initially', (WidgetTester tester) async {
      // Arrange
      when(mockMealRepository.getMealsByLetter(any))
          .thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>.value(
            value: mealBloc,
            child: const MealsPage(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading meals...'), findsOneWidget);
    });

    testWidgets('should show empty state when no meals found', (WidgetTester tester) async {
      // Arrange
      when(mockMealRepository.getMealsByLetter(any))
          .thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>.value(
            value: mealBloc,
            child: const MealsPage(),
          ),
        ),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No meals found'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show meals list when data is available', (WidgetTester tester) async {
      // Arrange
      final mockMeals = [
        const Meal(
          id: '1',
          name: 'Chicken Curry',
          thumbnail: 'https://example.com/chicken.jpg',
          category: 'Main Course',
          instructions: 'Cook chicken with curry spices',
          ingredients: {'Chicken': '500g', 'Curry Powder': '2 tbsp'},
        ),
        const Meal(
          id: '2',
          name: 'Beef Stir Fry',
          thumbnail: 'https://example.com/beef.jpg',
          category: 'Main Course',
          instructions: 'Stir fry beef with vegetables',
          ingredients: {'Beef': '400g', 'Vegetables': '300g'},
        ),
      ];

      when(mockMealRepository.getMealsByLetter(any))
          .thenAnswer((_) async => mockMeals);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>.value(
            value: mealBloc,
            child: const MealsPage(),
          ),
        ),
      );

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Chicken Curry'), findsOneWidget);
      expect(find.text('Beef Stir Fry'), findsOneWidget);
      expect(find.text('Main Course'), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show error state when API call fails', (WidgetTester tester) async {
      // Arrange
      when(mockMealRepository.getMealsByLetter(any))
          .thenThrow(Exception('Network error'));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>.value(
            value: mealBloc,
            child: const MealsPage(),
          ),
        ),
      );

      // Wait for loading to complete and error to show
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Error loading meals'), findsOneWidget);
      expect(find.text('Please try again later'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should refresh meals when pull to refresh is triggered', (WidgetTester tester) async {
      // Arrange
      final initialMeals = [
        const Meal(
          id: '1',
          name: 'Chicken Curry',
          thumbnail: 'https://example.com/chicken.jpg',
          category: 'Main Course',
          instructions: 'Cook chicken with curry spices',
          ingredients: {'Chicken': '500g', 'Curry Powder': '2 tbsp'},
        ),
      ];

      final refreshedMeals = [
        const Meal(
          id: '1',
          name: 'Chicken Curry',
          thumbnail: 'https://example.com/chicken.jpg',
          category: 'Main Course',
          instructions: 'Cook chicken with curry spices',
          ingredients: {'Chicken': '500g', 'Curry Powder': '2 tbsp'},
        ),
        const Meal(
          id: '2',
          name: 'New Recipe',
          thumbnail: 'https://example.com/new.jpg',
          category: 'Dessert',
          instructions: 'Make a delicious dessert',
          ingredients: {'Sugar': '100g', 'Flour': '200g'},
        ),
      ];

      when(mockMealRepository.getMealsByLetter(any))
          .thenAnswer((_) async => initialMeals)
          .thenAnswer((_) async => refreshedMeals);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MealBloc>.value(
            value: mealBloc,
            child: const MealsPage(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Chicken Curry'), findsOneWidget);
      expect(find.text('New Recipe'), findsNothing);

      // Trigger refresh
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Verify refreshed state
      expect(find.text('Chicken Curry'), findsOneWidget);
      expect(find.text('New Recipe'), findsOneWidget);
    });
  });
}
