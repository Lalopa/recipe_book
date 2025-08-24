import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/core/theme/theme.dart';
import 'package:recipe_book/core/utils/constants.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
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

            await navigator.pushNamed(
              AppRoutesNames.mealDetail,
              arguments: {'meal': meal.copyWith(isFavorite: isFavorite)},
            );

            if (context.mounted) {
              favoriteBloc.add(const FavoritesLoaded());
            }
          },
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
                    MealImageWidget(
                      imageUrl: meal.thumbnail,
                      height: 120,
                      width: MediaQuery.of(context).size.width,
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
                  child: FavoriteButtonWidget(
                    mealId: meal.id,
                    isFavorite: isFavorite,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
