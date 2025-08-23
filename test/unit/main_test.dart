import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/main.dart' as app;

import 'features/meals/presentation/bloc/meal_bloc_test.mocks.dart';

@GenerateMocks([GetMealsByLetter])
void main() {
  group('Main App', () {
    late MockGetMealsByLetter mockGetMealsByLetter;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await GetIt.instance.reset();

      mockGetMealsByLetter = MockGetMealsByLetter();
      when(mockGetMealsByLetter(any)).thenAnswer((_) async => []);
      await initDependencies();
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    testWidgets('should build MyApp widget', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());

      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should have correct app title', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Recipe Book');
    });

    testWidgets('should have theme configured', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
    });

    testWidgets('should have route generation configured', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.onGenerateRoute, isNotNull);
    });

    testWidgets('should have initial route configured', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.initialRoute, '/');
    });
  });
}
