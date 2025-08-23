import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/core/theme/theme.dart';
import 'package:recipe_book/features/favorites/domain/entities/favorite_meal.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_image_widget.dart';

class FavoriteMealWidget extends StatelessWidget {
  const FavoriteMealWidget({
    required this.meal,
    super.key,
  });

  final FavoriteMeal meal;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                final isFavorite = state.favoriteStatuses[meal.id] ?? false;
                return FavoriteButtonWidget(
                  mealId: meal.id,
                  isFavorite: isFavorite,
                  size: 20,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
