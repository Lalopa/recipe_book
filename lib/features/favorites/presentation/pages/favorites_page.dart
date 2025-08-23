import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_meal_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/custom_app_bar_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Cargar favoritos al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteBloc>().add(const FavoritesLoaded());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.favoriteMeals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Don't have favorites yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add meals to your favorites by tapping the heart',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoriteBloc>().add(const FavoritesLoaded());
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: state.favoriteMeals.length,
              itemBuilder: (context, index) {
                final meal = state.favoriteMeals[index];
                return FavoriteMealWidget(meal: meal);
              },
            ),
          );
        },
      ),
    );
  }
}
