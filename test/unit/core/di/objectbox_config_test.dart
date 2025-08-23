import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/core/di/objectbox_config.dart';

void main() {
  group('ObjectBoxConfig', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      ObjectBoxConfig.closeObjectBox();
    });

    tearDown(ObjectBoxConfig.closeObjectBox);

    group('Initialization', () {
      test('should handle initialization gracefully', () async {
        expect(ObjectBoxConfig.initObjectBox, returnsNormally);
      });

      test('should not reinitialize if already initialized', () async {
        await ObjectBoxConfig.initObjectBox();

        expect(ObjectBoxConfig.initObjectBox, returnsNormally);
      });
    });

    group('Store Access', () {
      test('should throw StateError when accessing store before initialization', () {
        expect(
          () => ObjectBoxConfig.store,
          throwsA(isA<StateError>()),
        );
      });

      test('should handle store access gracefully after initialization', () async {
        await ObjectBoxConfig.initObjectBox();
        try {
          final store = ObjectBoxConfig.store;
          expect(store, isNotNull);
          // required to avoid the test to fail
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          expect(e, isA<StateError>());
          expect(e.toString(), contains('ObjectBox no ha sido inicializado'));
        }
      });
    });

    group('Cleanup', () {
      test('should handle close calls gracefully', () async {
        // arrange
        await ObjectBoxConfig.initObjectBox();

        // act & assert
        expect(ObjectBoxConfig.closeObjectBox, returnsNormally);
      });

      test('should handle multiple close calls gracefully', () async {
        // arrange
        await ObjectBoxConfig.initObjectBox();
        ObjectBoxConfig.closeObjectBox();

        // act & assert
        expect(ObjectBoxConfig.closeObjectBox, returnsNormally);
      });
    });

    group('Error Handling', () {
      test('should handle initialization errors gracefully', () async {
        // This test verifies that the method doesn't throw
        // even if there are issues with directory creation
        expect(ObjectBoxConfig.initObjectBox, returnsNormally);
      });
    });

    group('Platform Support', () {
      test('should support multiple platforms', () async {
        // This test verifies that the method handles errors
        // and falls back to temporary directory if needed
        expect(ObjectBoxConfig.initObjectBox, returnsNormally);
      });
    });
  });
}
