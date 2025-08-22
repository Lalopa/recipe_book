import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_book/core/theme/theme.dart';

class MealPreviewWidgetError extends StatelessWidget {
  const MealPreviewWidgetError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(FontAwesomeIcons.triangleExclamation, size: 40, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              'Error loading meal. Please try again later.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme().textTheme.bodyMedium!.copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
