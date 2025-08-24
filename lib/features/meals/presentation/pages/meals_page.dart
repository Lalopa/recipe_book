import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/core/di/injector.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';
import 'package:recipe_book/features/meals/presentation/widgets/custom_app_bar_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_loading_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_preview_error_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_preview_widget.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MealBloc>(),
      child: const MealsView(),
    );
  }
}

class MealsView extends StatefulWidget {
  const MealsView({super.key});

  @override
  State<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteBloc>().add(const FavoritesLoaded());
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final threshold = _controller.position.maxScrollExtent * 0.9;
    if (_controller.position.pixels >= threshold) {
      context.read<MealBloc>().add(const MealFetched());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAppBarWidget(),
        body: BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            switch (state.status) {
              case MealStatus.success:
                return MealResultsWidget(
                  controller: _controller,
                  meals: state.meals,
                  hasReachedMax: state.hasReachedMax,
                );
              case MealStatus.failure:
                return const MealPreviewWidgetError();
              case MealStatus.initial:
                context.read<MealBloc>().add(const MealFetched());
              case MealStatus.loading:
                if (state.meals.isNotEmpty) {
                  return MealResultsWidget(
                    controller: _controller,
                    meals: state.meals,
                    hasReachedMax: state.hasReachedMax,
                  );
                }
            }
            return const MealLoadingWidget();
          },
        ),
      ),
    );
  }
}

class MealResultsWidget extends StatelessWidget {
  const MealResultsWidget({
    required ScrollController controller,
    required this.meals,
    required this.hasReachedMax,
    super.key,
  }) : _controller = controller;

  final ScrollController _controller;
  final List<Meal> meals;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<MealBloc>().add(const MealRefreshed()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.read<MainCubit>().setTab(1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Ex: chicken, pasta, salad',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  ObjectBoxCacheManager.instance.clearAllCache();
                  context.read<MealBloc>().add(const MealRefreshed());
                },
                child: const Text('Limpiar Cache'),
              ),
            ),
          Expanded(
            child: meals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No results found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We are working on it',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey[500],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    controller: _controller,
                    itemCount: meals.length + (hasReachedMax ? 0 : 1),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.65,
                        ),
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      if (index >= meals.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final meal = meals[index];
                      return MealPreviewWidget(meal: meal);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
