import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/presentation/pages/meals_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = const [
    MealsPage(),
    SizedBox(),
    SizedBox(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MainCubit>(),
      child: BlocBuilder<MainCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: _pages[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: context.read<MainCubit>().setTab,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu),
                  label: 'Recipes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
