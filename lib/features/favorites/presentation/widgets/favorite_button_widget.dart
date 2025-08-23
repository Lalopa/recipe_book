import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';

class FavoriteButtonWidget extends StatelessWidget {
  const FavoriteButtonWidget({
    required this.mealId,
    required this.isFavorite,
    this.onFavoriteToggled,
    this.size = 24.0,
    super.key,
  });

  final String mealId;
  final bool isFavorite;
  final double size;
  final void Function(String)? onFavoriteToggled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onFavoriteToggled?.call(mealId);
        context.read<FavoriteBloc>().add(FavoriteToggled(mealId));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey,
          size: size,
        ),
      ),
    );
  }
}
