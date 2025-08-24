import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_book/core/di/injection.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';

void main() {
  group('Extended Dependency Injection', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      GetIt.instance.reset();
    });

    group('Basic Dependencies', () {
      test('should register MainCubit', () async {
        // act
        await configureDependencies();

        // assert
        expect(GetIt.instance.isRegistered<MainCubit>(), isTrue);
      });

      test('should register Dio', () async {
        // act
        await configureDependencies();

        // assert
        expect(GetIt.instance.isRegistered<Dio>(), isTrue);
      });

      test('should register MainCubit as factory', () async {
        // act
        await configureDependencies();

        // assert
        final instance1 = GetIt.instance<MainCubit>();
        final instance2 = GetIt.instance<MainCubit>();
        expect(identical(instance1, instance2), isFalse);
      });

      test('should register Dio as lazySingleton', () async {
        // act
        await configureDependencies();

        // assert
        final instance1 = GetIt.instance<Dio>();
        final instance2 = GetIt.instance<Dio>();
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Dependency Types', () {
      test('should return correct MainCubit type', () async {
        // act
        await configureDependencies();

        // assert
        expect(GetIt.instance<MainCubit>(), isA<MainCubit>());
      });

      test('should return correct Dio type', () async {
        // act
        await configureDependencies();

        // assert
        expect(GetIt.instance<Dio>(), isA<Dio>());
      });
    });

    group('Dependency Registration', () {
      test('should resolve all basic dependencies in correct order', () async {
        // act
        await configureDependencies();

        // assert
        // Verify that all basic dependencies are registered
        expect(GetIt.instance.isRegistered<Dio>(), isTrue);
        expect(GetIt.instance.isRegistered<MainCubit>(), isTrue);
      });
    });

    group('Performance', () {
      test('should initialize dependencies quickly', () async {
        // act
        final stopwatch = Stopwatch()..start();
        await configureDependencies();
        stopwatch.stop();

        // assert
        // Dependencies should initialize in less than 1 second
        expect(stopwatch.elapsed.inMilliseconds, lessThan(1000));
      });

      test('should resolve basic dependencies quickly', () async {
        // arrange
        await configureDependencies();

        // act
        final stopwatch = Stopwatch()..start();
        GetIt.instance<MainCubit>();
        GetIt.instance<Dio>();
        stopwatch.stop();

        // assert
        // Dependency resolution should be very fast
        expect(stopwatch.elapsed.inMicroseconds, lessThan(1000));
      });
    });
  });
}
