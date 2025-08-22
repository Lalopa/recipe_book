import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/utils/constants.dart';

void main() {
  group('Constants', () {
    test('should have correct app name', () {
      expect(Constants.appName, 'Recipe Book');
    });
  });

  group('AppRoutesNames', () {
    test('should have correct home route', () {
      expect(AppRoutesNames.home, '/');
    });

    test('should have correct meals route', () {
      expect(AppRoutesNames.meals, '/meals');
    });

    test('should be constants', () {
      expect(Constants.appName, isA<String>());
      expect(AppRoutesNames.home, isA<String>());
      expect(AppRoutesNames.meals, isA<String>());
    });
  });
}
