import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/features/main/presentation/cubit/main_cubit.dart';

void main() {
  group('MainCubit', () {
    late MainCubit cubit;

    setUp(() {
      cubit = MainCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be 0', () {
      expect(cubit.state, 0);
    });

    blocTest<MainCubit, int>(
      'emits [1] when setTab(1) is called',
      build: () => cubit,
      act: (cubit) => cubit.setTab(1),
      expect: () => [1],
    );

    blocTest<MainCubit, int>(
      'emits [2] when setTab(2) is called',
      build: () => cubit,
      act: (cubit) => cubit.setTab(2),
      expect: () => [2],
    );

    blocTest<MainCubit, int>(
      'emits [0] when setTab(0) is called',
      build: () => cubit,
      act: (cubit) => cubit.setTab(0),
      expect: () => [0],
    );

    blocTest<MainCubit, int>(
      'emits [5] when setTab(5) is called',
      build: () => cubit,
      act: (cubit) => cubit.setTab(5),
      expect: () => [5],
    );

    blocTest<MainCubit, int>(
      'emits [10] when setTab(10) is called',
      build: () => cubit,
      act: (cubit) => cubit.setTab(10),
      expect: () => [10],
    );

    test('should handle multiple setTab calls', () {
      cubit.setTab(1);
      expect(cubit.state, 1);

      cubit.setTab(3);
      expect(cubit.state, 3);

      cubit.setTab(0);
      expect(cubit.state, 0);

      cubit.setTab(7);
      expect(cubit.state, 7);
    });

    test('should handle negative values', () {
      cubit.setTab(-1);
      expect(cubit.state, -1);

      cubit.setTab(-5);
      expect(cubit.state, -5);
    });
  });
}
