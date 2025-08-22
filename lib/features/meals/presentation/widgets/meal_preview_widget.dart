import 'package:flutter/material.dart';
import 'package:recipe_book/core/theme/theme.dart';
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
    return GestureDetector(
      onTap: () => {},
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
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: meal.isFavorite ? Colors.red : Colors.white,
                        size: 30,
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: meal.isFavorite ? Colors.white : Colors.black,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
