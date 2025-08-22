import 'package:flutter/material.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/presentation/widgets/meal_image_widget.dart';

class RandomMealWidget extends StatelessWidget {
  const RandomMealWidget({
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MealImageWidget(
              imageUrl: meal.thumbnail,
              height: 120,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                meal.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
