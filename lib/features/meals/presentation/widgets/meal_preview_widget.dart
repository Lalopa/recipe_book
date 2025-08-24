import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';
import 'package:recipe_book/core/di/injection.dart';
import 'package:recipe_book/core/theme/theme.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/pages/meal_detail_page.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_image_widget.dart';

class MealPreviewWidget extends StatelessWidget {
  const MealPreviewWidget({
    required this.meal,
    super.key,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final isFavorite = state.favoriteStatuses[meal.id] ?? false;
        return GestureDetector(
          onTap: () async {
            final navigator = Navigator.of(context);
            final favoriteBloc = context.read<FavoriteBloc>();
            final isFavorite = state.favoriteStatuses[meal.id] ?? false;

            var mealToShow = meal;
            if (meal.ingredients.isEmpty) {
              final cacheManager = getIt<ObjectBoxCacheManager>();
              final cachedMeal = await cacheManager.getCachedMeal(meal.id);
              if (cachedMeal != null) {
                mealToShow = cachedMeal.toEntity().copyWith(isFavorite: isFavorite);
              } else {
                mealToShow = meal.copyWith(isFavorite: isFavorite);
              }
            } else {
              mealToShow = meal.copyWith(isFavorite: isFavorite);
            }

            await navigator.push<MealDetailPage>(
              PageRouteBuilder<MealDetailPage>(
                pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
                  create: (context) => getIt<FavoriteBloc>(),
                  child: MealDetailPage(
                    meal: mealToShow,
                  ),
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0, 1);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;

                  final tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );

            if (context.mounted) {
              favoriteBloc.add(const FavoritesLoaded());
            }
          },
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color(0xFF68B684),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: 'meal-image-${meal.id}',
                              child: MealImageWidget(
                                imageUrl: meal.thumbnail,
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      'Category: ${meal.category}',
                                      style: AppTheme.lightTheme().textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        meal.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      meal.instructions,
                                      maxLines: 4,
                                      overflow: TextOverflow.fade,
                                      style: AppTheme.lightTheme().textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AnimatedScale(
                            scale: isFavorite ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: FavoriteButtonWidget(
                              mealId: meal.id,
                              isFavorite: isFavorite,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
