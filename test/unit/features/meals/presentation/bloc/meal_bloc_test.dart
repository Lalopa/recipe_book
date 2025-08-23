import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

import 'meal_bloc_test.mocks.dart';

@GenerateMocks([GetMealsByLetter])
void main() {
  group('MealBloc', () {
    late MockGetMealsByLetter mockGetMealsByLetter;

    setUp(() {
      mockGetMealsByLetter = MockGetMealsByLetter();
    });

    test('initial state is correct', () {
      expect(
        () => MealBloc(mockGetMealsByLetter),
        returnsNormally,
      );
    });

    group('MealFetched', () {
      blocTest<MealBloc, MealState>(
        'emits [loading, success] when meals are fetched successfully',
        build: () {
          // Configurar mock para la letra 'a' que se llama primero
          when(mockGetMealsByLetter('a')).thenAnswer(
            (_) async => [
              const Meal(
                id: '1',
                name: 'Test Meal 1',
                thumbnail: 'test1.jpg',
                category: 'Test Category',
                instructions: 'Test instructions 1',
                ingredients: {'ingredient1': 'measure1'},
              ),
              const Meal(
                id: '2',
                name: 'Test Meal 2',
                thumbnail: 'test2.jpg',
                category: 'Test Category',
                instructions: 'Test instructions 2',
                ingredients: {'ingredient2': 'measure2'},
              ),
            ],
          );

          // Configurar mock para otras letras que se puedan llamar
          for (var i = 1; i < 26; i++) {
            final letter = String.fromCharCode(97 + i);
            when(mockGetMealsByLetter(letter)).thenAnswer((_) async => <Meal>[]);
          }

          return MealBloc(mockGetMealsByLetter);
        },
        act: (bloc) => bloc.add(const MealFetched()),
        expect: () => [
          const MealState(
            status: MealStatus.loading,
            meals: [],
            letterIndex: 0,
            offsetInLetter: 0,
            hasReachedMax: false,
          ),
          const MealState(
            status: MealStatus.success,
            meals: [
              Meal(
                id: '1',
                name: 'Test Meal 1',
                thumbnail: 'test1.jpg',
                category: 'Test Category',
                instructions: 'Test instructions 1',
                ingredients: {'ingredient1': 'measure1'},
              ),
              Meal(
                id: '2',
                name: 'Test Meal 2',
                thumbnail: 'test2.jpg',
                category: 'Test Category',
                instructions: 'Test instructions 2',
                ingredients: {'ingredient2': 'measure2'},
              ),
            ],
            letterIndex: 26,
            offsetInLetter: 0,
            hasReachedMax: false,
          ),
        ],
      );

      blocTest<MealBloc, MealState>(
        'emits [loading, failure] when meals fetch fails',
        build: () {
          when(mockGetMealsByLetter('a')).thenThrow(Exception('Failed to fetch meals'));

          // Configurar mock para otras letras
          for (var i = 1; i < 26; i++) {
            final letter = String.fromCharCode(97 + i);
            when(mockGetMealsByLetter(letter)).thenAnswer((_) async => <Meal>[]);
          }

          return MealBloc(mockGetMealsByLetter);
        },
        act: (bloc) => bloc.add(const MealFetched()),
        expect: () => [
          const MealState(
            status: MealStatus.loading,
            meals: [],
            letterIndex: 0,
            offsetInLetter: 0,
            hasReachedMax: false,
          ),
          const MealState(
            status: MealStatus.failure,
            meals: [],
            letterIndex: 0,
            offsetInLetter: 0,
            hasReachedMax: false,
          ),
        ],
      );
    });

    group('MealRefreshed', () {
      blocTest<MealBloc, MealState>(
        'emits [initial] and then fetches meals',
        build: () {
          when(mockGetMealsByLetter('a')).thenAnswer(
            (_) async => [
              const Meal(
                id: '1',
                name: 'Test Meal 1',
                thumbnail: 'test1.jpg',
                category: 'Test Category',
                instructions: 'Test instructions 1',
                ingredients: {'ingredient1': 'measure1'},
              ),
            ],
          );

          // Configurar mock para otras letras
          for (var i = 1; i < 26; i++) {
            final letter = String.fromCharCode(97 + i);
            when(mockGetMealsByLetter(letter)).thenAnswer((_) async => <Meal>[]);
          }

          return MealBloc(mockGetMealsByLetter);
        },
        act: (bloc) => bloc.add(const MealRefreshed()),
        expect: () => [
          const MealState.initial(),
          const MealState(
            status: MealStatus.loading,
            meals: [],
            letterIndex: 0,
            offsetInLetter: 0,
            hasReachedMax: false,
          ),
          const MealState(
            status: MealStatus.success,
            meals: [
              Meal(
                id: '1',
                name: 'Test Meal 1',
                thumbnail: 'test1.jpg',
                category: 'Test Category',
                instructions: 'Test instructions 1',
                ingredients: {'ingredient1': 'measure1'},
              ),
            ],
            letterIndex: 26,
            offsetInLetter: 0,
            hasReachedMax: false,
          ),
        ],
      );
    });
  });
}
