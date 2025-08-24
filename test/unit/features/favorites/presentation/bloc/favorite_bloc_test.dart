import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/favorites/domain/usecases/check_favorite_status.dart';
import 'package:recipe_book/features/favorites/domain/usecases/get_favorite_meals.dart';
import 'package:recipe_book/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:recipe_book/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

import 'favorite_bloc_test.mocks.dart';

@GenerateMocks([
  GetFavoriteMeals,
  ToggleFavorite,
  CheckFavoriteStatus,
])
void main() {
  group('FavoriteBloc', () {
    late FavoriteBloc bloc;
    late MockGetFavoriteMeals mockGetFavoriteMeals;
    late MockToggleFavorite mockToggleFavorite;
    late MockCheckFavoriteStatus mockCheckFavoriteStatus;

    setUp(() {
      mockGetFavoriteMeals = MockGetFavoriteMeals();
      mockToggleFavorite = MockToggleFavorite();
      mockCheckFavoriteStatus = MockCheckFavoriteStatus();
      bloc = FavoriteBloc(
        mockGetFavoriteMeals,
        mockToggleFavorite,
        mockCheckFavoriteStatus,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be FavoriteState.initial', () {
      expect(bloc.state, const FavoriteState.initial());
    });

    group('FavoritesLoaded', () {
      final testFavoriteMeals = [
        const Meal(
          id: 'meal-1',
          name: 'Test Meal 1',
          thumbnail: 'https://example.com/meal1.jpg',
          category: 'Test Category 1',
          instructions: 'Test instructions 1',
          ingredients: {'ingredient1': 'amount1'},
        ),
        const Meal(
          id: 'meal-2',
          name: 'Test Meal 2',
          thumbnail: 'https://example.com/meal2.jpg',
          category: 'Test Category 2',
          instructions: 'Test instructions 2',
          ingredients: {'ingredient2': 'amount2'},
        ),
      ];

      blocTest<FavoriteBloc, FavoriteState>(
        'should emit loading state then loaded state with favorites',
        build: () {
          when(mockGetFavoriteMeals()).thenAnswer((_) async => testFavoriteMeals);
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoritesLoaded()),
        expect: () => [
          const FavoriteState(
            status: FavoriteStatus.loading,
            favoriteMeals: [],
            isLoading: true,
            favoriteStatuses: {},
          ),
          FavoriteState(
            status: FavoriteStatus.success,
            favoriteMeals: testFavoriteMeals,
            isLoading: false,
            favoriteStatuses: const {
              'meal-1': true,
              'meal-2': true,
            },
          ),
        ],
        verify: (_) {
          verify(mockGetFavoriteMeals()).called(1);
        },
      );

      blocTest<FavoriteBloc, FavoriteState>(
        'should emit loading state then empty state when no favorites',
        build: () {
          when(mockGetFavoriteMeals()).thenAnswer((_) async => <Meal>[]);
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoritesLoaded()),
        expect: () => [
          const FavoriteState(
            status: FavoriteStatus.loading,
            favoriteMeals: [],
            isLoading: true,
            favoriteStatuses: {},
          ),
          const FavoriteState(
            status: FavoriteStatus.success,
            favoriteMeals: [],
            isLoading: false,
            favoriteStatuses: {},
          ),
        ],
        verify: (_) {
          verify(mockGetFavoriteMeals()).called(1);
        },
      );

      blocTest<FavoriteBloc, FavoriteState>(
        'should emit loading state then error state on exception',
        build: () {
          when(mockGetFavoriteMeals()).thenThrow(Exception('Test error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoritesLoaded()),
        expect: () => [
          const FavoriteState(
            isLoading: true,
            status: FavoriteStatus.loading,
            favoriteMeals: [],
            favoriteStatuses: {},
          ),
          const FavoriteState(
            isLoading: false,
            status: FavoriteStatus.failure,
            favoriteMeals: [],
            favoriteStatuses: {},
          ),
        ],
        verify: (_) {
          verify(mockGetFavoriteMeals()).called(1);
        },
      );
    });

    group('FavoriteToggled', () {
      const mealId = 'test-meal-id';

      blocTest<FavoriteBloc, FavoriteState>(
        'should toggle favorite status and reload favorites',
        build: () {
          when(mockToggleFavorite(mealId)).thenAnswer((_) async {});
          when(mockCheckFavoriteStatus(mealId)).thenAnswer((_) async => true);
          when(mockGetFavoriteMeals()).thenAnswer((_) async => <Meal>[]);
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoriteToggled(mealId)),
        expect: () => [
          const FavoriteState(
            status: FavoriteStatus.initial,
            favoriteMeals: [],
            isLoading: false,
            favoriteStatuses: {mealId: true},
          ),
          const FavoriteState(
            status: FavoriteStatus.loading,
            favoriteMeals: [],
            isLoading: true,
            favoriteStatuses: {mealId: true},
          ),
          const FavoriteState(
            status: FavoriteStatus.success,
            favoriteMeals: [],
            isLoading: false,
            favoriteStatuses: {mealId: false},
          ),
        ],
        verify: (_) {
          verify(mockToggleFavorite(mealId)).called(1);
          verify(mockCheckFavoriteStatus(mealId)).called(1);
          verify(mockGetFavoriteMeals()).called(1);
        },
      );

      blocTest<FavoriteBloc, FavoriteState>(
        'should handle toggle error gracefully',
        build: () {
          when(mockToggleFavorite(mealId)).thenThrow(Exception('Toggle error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoriteToggled(mealId)),
        expect: () => const <FavoriteState>[],
        verify: (_) {
          verify(mockToggleFavorite(mealId)).called(1);
        },
      );
    });

    group('FavoriteStatusChecked', () {
      const mealId = 'test-meal-id';

      blocTest<FavoriteBloc, FavoriteState>(
        'should update favorite status when checking',
        build: () {
          when(mockCheckFavoriteStatus(mealId)).thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoriteStatusChecked(mealId)),
        expect: () => [
          const FavoriteState(
            status: FavoriteStatus.success,
            favoriteMeals: [],
            isLoading: false,
            favoriteStatuses: {mealId: true},
          ),
        ],
        verify: (_) {
          verify(mockCheckFavoriteStatus(mealId)).called(1);
        },
      );

      blocTest<FavoriteBloc, FavoriteState>(
        'should update favorite status to false when checking',
        build: () {
          when(mockCheckFavoriteStatus(mealId)).thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoriteStatusChecked(mealId)),
        expect: () => [
          const FavoriteState(
            status: FavoriteStatus.success,
            favoriteMeals: [],
            isLoading: false,
            favoriteStatuses: {mealId: false},
          ),
        ],
        verify: (_) {
          verify(mockCheckFavoriteStatus(mealId)).called(1);
        },
      );

      blocTest<FavoriteBloc, FavoriteState>(
        'should handle status check error gracefully',
        build: () {
          when(mockCheckFavoriteStatus(mealId)).thenThrow(Exception('Status check error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FavoriteStatusChecked(mealId)),
        expect: () => const <FavoriteState>[],
        verify: (_) {
          verify(mockCheckFavoriteStatus(mealId)).called(1);
        },
      );
    });
  });
}
