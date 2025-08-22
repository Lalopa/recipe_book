import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/utils/api_constants.dart';

void main() {
  group('ApiConstants', () {
    test('should have correct base URL', () {
      expect(ApiConstants.baseUrl, 'https://www.themealdb.com/api/json/v1/1');
    });

    test('should have correct search endpoint', () {
      expect(ApiConstants.search, '/search.php');
    });

    test('should be constants', () {
      expect(ApiConstants.baseUrl, isA<String>());
      expect(ApiConstants.search, isA<String>());
    });

    test('should have valid URL format', () {
      expect(ApiConstants.baseUrl, startsWith('https://'));
      expect(ApiConstants.search, startsWith('/'));
    });
  });
}
