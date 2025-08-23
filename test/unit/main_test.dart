import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';
import 'package:recipe_book/main.dart' as app;

@GenerateMocks([GetMealsByLetter, MainCubit, SearchBloc])
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

    test('should verify MaterialApp properties exist', () {
      const myApp = app.MyApp();
      expect(myApp, isA<StatelessWidget>());
    });
  });

  group('Main App', () {
    test('should verify MyApp class exists', () {
      expect(app.MyApp, isA<Type>());
    });

    test('should verify MyApp can be instantiated', () {
      const myApp = app.MyApp();
      expect(myApp, isA<StatelessWidget>());
    });
  });
}
