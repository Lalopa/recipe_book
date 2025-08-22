import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/routes/app_router.dart';
import 'package:recipe_book/core/utils/constants.dart';
import 'package:recipe_book/features/main/presentation/pages/main_page.dart';
import 'package:recipe_book/features/meals/presentation/pages/meals_page.dart';

class MockBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('AppRoutes', () {
    test('should generate home route correctly', () {
      final route = AppRoutes.generateRoute(
        const RouteSettings(name: AppRoutesNames.home),
      );

      expect(route, isA<MaterialPageRoute<dynamic>>());
      expect(route.settings.name, AppRoutesNames.home);
    });

    test('should generate meals route correctly', () {
      final route = AppRoutes.generateRoute(
        const RouteSettings(name: AppRoutesNames.meals),
      );

      expect(route, isA<MaterialPageRoute<dynamic>>());
      expect(route.settings.name, AppRoutesNames.meals);
    });

    test('should generate default route for unknown route', () {
      final route = AppRoutes.generateRoute(
        const RouteSettings(name: '/unknown'),
      );

      expect(route, isA<MaterialPageRoute<dynamic>>());
      expect(route.settings.name, '/unknown');
    });

    test('should generate default route for null route name', () {
      final route = AppRoutes.generateRoute(
        const RouteSettings(),
      );

      expect(route, isA<MaterialPageRoute<dynamic>>());
      expect(route.settings.name, isNull);
    });

    test('should build correct widget for home route', () {
      final route =
          AppRoutes.generateRoute(
                const RouteSettings(name: AppRoutesNames.home),
              )
              as MaterialPageRoute;

      final widget = route.builder(MockBuildContext());
      expect(widget, isA<MainPage>());
    });

    test('should build correct widget for meals route', () {
      final route =
          AppRoutes.generateRoute(
                const RouteSettings(name: AppRoutesNames.meals),
              )
              as MaterialPageRoute;

      final widget = route.builder(MockBuildContext());
      expect(widget, isA<MealsPage>());
    });

    test('should build Scaffold with error message for unknown route', () {
      final route =
          AppRoutes.generateRoute(
                const RouteSettings(name: '/unknown'),
              )
              as MaterialPageRoute;

      final widget = route.builder(MockBuildContext());
      expect(widget, isA<Scaffold>());

      final scaffold = widget as Scaffold;
      expect(scaffold.body, isA<Center>());

      final center = scaffold.body! as Center;
      expect(center.child, isA<Text>());

      final text = center.child! as Text;
      expect(text.data, 'Route not found');
    });
  });
}
