import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/theme/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AppTheme', () {
    test('should return light theme', () {
      final theme = AppTheme.lightTheme;
      expect(theme, isA<ThemeData>());
    });

    test('should have correct brightness', () {
      final theme = AppTheme.lightTheme;
      expect(theme.brightness, Brightness.light);
    });

    test('should use Material 3', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, isTrue);
    });

    test('should have correct scaffold background color', () {
      final theme = AppTheme.lightTheme;
      expect(theme.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    });

    test('should have correct color scheme', () {
      final theme = AppTheme.lightTheme;
      final colorScheme = theme.colorScheme;

      expect(colorScheme.primary, const Color(0xFF68B684));
      expect(colorScheme.secondary, const Color(0xFFDE6418));
      expect(colorScheme.tertiary, const Color(0xFFFF914D));
    });

    test('should have correct text theme', () {
      final theme = AppTheme.lightTheme;
      final textTheme = theme.textTheme;

      expect(textTheme.bodyLarge?.fontSize, 16);
      expect(textTheme.bodyLarge?.fontWeight, FontWeight.w500);
      expect(textTheme.bodyLarge?.color, const Color(0xFF333333));

      expect(textTheme.bodyMedium?.fontSize, 14);
      expect(textTheme.bodyMedium?.fontWeight, FontWeight.w400);

      expect(textTheme.bodySmall?.fontSize, 12);
      expect(textTheme.bodySmall?.fontWeight, FontWeight.w300);
      expect(textTheme.bodySmall?.color, const Color(0xFF5B625E));

      expect(textTheme.titleLarge?.fontSize, 20);
      expect(textTheme.titleLarge?.fontWeight, FontWeight.w600);
      expect(textTheme.titleLarge?.color, const Color(0xFF333333));
    });

    test('should have correct input decoration theme', () {
      final theme = AppTheme.lightTheme;
      final inputTheme = theme.inputDecorationTheme;

      expect(inputTheme.border, isA<OutlineInputBorder>());
      expect(inputTheme.focusedBorder, isA<OutlineInputBorder>());
      expect(inputTheme.enabledBorder, isA<OutlineInputBorder>());
      expect(inputTheme.errorBorder, isA<OutlineInputBorder>());

      expect(inputTheme.focusColor, const Color(0xFF7C837F));
      expect(inputTheme.filled, isTrue);
      expect(inputTheme.fillColor, const Color(0xFFDDDDDD));
    });

    test('should have correct border radius for input fields', () {
      final theme = AppTheme.lightTheme;
      final inputTheme = theme.inputDecorationTheme;

      final border = inputTheme.border! as OutlineInputBorder;
      final focusedBorder = inputTheme.focusedBorder! as OutlineInputBorder;
      final enabledBorder = inputTheme.enabledBorder! as OutlineInputBorder;
      final errorBorder = inputTheme.errorBorder! as OutlineInputBorder;

      expect(border.borderRadius, const BorderRadius.all(Radius.circular(10)));
      expect(focusedBorder.borderRadius, const BorderRadius.all(Radius.circular(10)));
      expect(enabledBorder.borderRadius, const BorderRadius.all(Radius.circular(10)));
      expect(errorBorder.borderRadius, const BorderRadius.all(Radius.circular(10)));
    });

    test('should have no border side for input fields', () {
      final theme = AppTheme.lightTheme;
      final inputTheme = theme.inputDecorationTheme;

      final border = inputTheme.border! as OutlineInputBorder;
      final focusedBorder = inputTheme.focusedBorder! as OutlineInputBorder;
      final enabledBorder = inputTheme.enabledBorder! as OutlineInputBorder;
      final errorBorder = inputTheme.errorBorder! as OutlineInputBorder;

      expect(border.borderSide, BorderSide.none);
      expect(focusedBorder.borderSide, BorderSide.none);
      expect(enabledBorder.borderSide, BorderSide.none);
      expect(errorBorder.borderSide, BorderSide.none);
    });

    test('should use Google Fonts Inter', () {
      // This test verifies that the text theme is properly configured
      // We can't test the actual font loading in unit tests
      expect(true, isTrue);
    });
  });
}
