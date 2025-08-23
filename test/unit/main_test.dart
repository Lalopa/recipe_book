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
  group('main function unit tests', () {
    test('should verify main function components exist', () {
      // Verificar que los componentes de main() existen y son accesibles
      expect(app.MyApp, isA<Type>());

      // Verificar que MyApp se puede instanciar
      const myApp = app.MyApp();
      expect(myApp, isA<StatelessWidget>());
    });

    test('should verify dependencies can be initialized', () async {
      // Test unitario para la inicialización de dependencias (parte de main)
      TestWidgetsFlutterBinding.ensureInitialized();
      await GetIt.instance.reset();
      await initDependencies();

      // Verificar que las dependencias están registradas
      expect(GetIt.instance.isRegistered<GetMealsByLetter>(), isTrue);
    });
  });

  group('MyApp widget tests', () {
    testWidgets('should create MyApp with default constructor', (WidgetTester tester) async {
      const myApp = app.MyApp();

      expect(myApp, isA<StatelessWidget>());
      expect(myApp.key, isNull);
    });

    testWidgets('should create MyApp with custom key', (WidgetTester tester) async {
      const key = Key('test-key');
      const myApp = app.MyApp(key: key);

      expect(myApp, isA<StatelessWidget>());
      expect(myApp.key, equals(key));
    });

    testWidgets('should build MaterialApp with all properties', (WidgetTester tester) async {
      const myApp = app.MyApp();

      await tester.pumpWidget(myApp);
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Verificar cada propiedad del MaterialApp (líneas 18-23)
      expect(materialApp.title, equals('Recipe Book')); // línea 19
      expect(materialApp.theme, isNotNull); // línea 20
      expect(materialApp.onGenerateRoute, isNotNull); // línea 21
      expect(materialApp.initialRoute, equals('/')); // línea 22
    });
  });

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
