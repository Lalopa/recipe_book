import 'package:flutter/material.dart';
import 'package:recipe_book/core/utils/constants.dart';
import 'package:recipe_book/features/main/presentation/pages/main_page.dart';
import 'package:recipe_book/features/meals/presentation/pages/meals_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesNames.home:
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
          settings: settings,
        );

      case AppRoutesNames.meals:
        return MaterialPageRoute(
          builder: (_) => const MealsPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
          settings: settings,
        );
    }
  }
}
