import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/cache/managers/objectbox_cache_manager.dart';

void main() {
  group('ObjectBoxCacheManager.normalizeQuery', () {
    late ObjectBoxCacheManager cacheManager;

    setUp(() {
      cacheManager = ObjectBoxCacheManager();
    });

    test('should trim whitespace and convert to lowercase', () {
      const query = '  HELLO  WORLD  ';
      const expected = 'hello  world';

      final result = cacheManager.normalizeQuery(query);

      expect(result, equals(expected));
    });

    test('should handle empty string', () {
      const query = '';
      const expected = '';

      final result = cacheManager.normalizeQuery(query);

      expect(result, equals(expected));
    });

    test('should handle string with only whitespace', () {
      const query = '   ';
      const expected = '';

      final result = cacheManager.normalizeQuery(query);

      expect(result, equals(expected));
    });

    test('should handle mixed case string', () {
      const query = 'HeLLo WoRLd';
      const expected = 'hello world';

      final result = cacheManager.normalizeQuery(query);

      expect(result, equals(expected));
    });

    test('should handle special characters and unicode', () {
      const query = 'Café au Lait! ñáéíóú';
      const expected = 'café au lait! ñáéíóú';

      final result = cacheManager.normalizeQuery(query);

      expect(result, equals(expected));
    });

    test('should handle numbers and symbols', () {
      const query = r'Recipe 123 !@#$%^&*()';
      const expected = r'recipe 123 !@#$%^&*()';

      final result = cacheManager.normalizeQuery(query);

      expect(result, equals(expected));
    });

    test('should handle long strings efficiently', () {
      final longString = 'A' * 1000;
      final expected = 'a' * 1000;

      final stopwatch = Stopwatch()..start();
      final result = cacheManager.normalizeQuery(longString);
      stopwatch.stop();

      expect(result, equals(expected));
      expect(stopwatch.elapsed.inMilliseconds, lessThan(100));
    });

    test('should produce consistent results', () {
      const query = '  TEST  QUERY  ';
      const expected = 'test  query';

      for (var i = 0; i < 10; i++) {
        final result = cacheManager.normalizeQuery(query);
        expect(result, equals(expected));
      }
    });
  });
}
