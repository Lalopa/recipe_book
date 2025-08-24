import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/core/utils/constants.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/main/presentation/pages/main_page.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/pages/meal_detail_page.dart';
import 'package:recipe_book/features/meals/presentation/pages/meals_page.dart';
import 'package:recipe_book/features/search/presentation/pages/search_page.dart';

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

      case AppRoutesNames.search:
        return MaterialPageRoute(
          builder: (_) => const SearchPage(),
          settings: settings,
        );

      case AppRoutesNames.mealDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['meal'] == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Meal not found')),
            ),
          );
        }
        final meal = args['meal'] as Meal;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<FavoriteBloc>(),
            child: MealDetailPage(meal: meal),
          ),
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
