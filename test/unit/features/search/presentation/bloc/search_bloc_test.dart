import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/usecases/search_meals.dart';
import 'package:recipe_book/features/search/presentation/bloc/search_bloc.dart';

import 'search_bloc_test.mocks.dart';

// Helper para crear Meal de prueba
Meal buildTestMeal({
  required String id,
  required String name,
  String? thumbnail,
  String? category,
  String? instructions,
  Map<String, String>? ingredients,
}) {
  return Meal(
    id: id,
    name: name,
    thumbnail: thumbnail ?? 'https://example.com/$id.jpg',
    category: category ?? 'Category $id',
    instructions: instructions ?? 'Instructions for $name',
    ingredients: ingredients ?? {'ingredient1': 'amount1'},
  );
}

// Datos de prueba
final List<Meal> testMeals = [
  buildTestMeal(id: '1', name: 'Chicken Pasta'),
  buildTestMeal(id: '2', name: 'Chicken Salad'),
  buildTestMeal(id: '3', name: 'Chicken Soup'),
];

@GenerateMocks([SearchMeals])
void main() {
  group('SearchBloc', () {
    late SearchBloc bloc;
    late MockSearchMeals mockSearchMeals;

    setUp(() {
      mockSearchMeals = MockSearchMeals();
      bloc = SearchBloc(mockSearchMeals);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be SearchState.initial', () {
      expect(bloc.state, const SearchState.initial());
    });

    blocTest<SearchBloc, SearchState>(
      'emits [initial] when SearchQueryChanged with empty query',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchQueryChanged('')),
      expect: () => [const SearchState.initial()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [initial] when SearchQueryChanged with whitespace only',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchQueryChanged('   ')),
      expect: () => [const SearchState.initial()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [initial with query] when SearchQueryChanged with short query',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchQueryChanged('a')),
      expect: () => [const SearchState.initial(query: 'a')],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [loading, success] when SearchQueryChanged with valid query succeeds',
      build: () {
        when(mockSearchMeals('chicken')).thenAnswer((_) async => testMeals);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('chicken')),
      expect: () => [
        const SearchState(
          status: SearchStatus.loading,
          query: 'chicken',
        ),
        SearchState(
          status: SearchStatus.success,
          meals: testMeals,
          query: 'chicken',
        ),
      ],
      verify: (_) {
        verify(mockSearchMeals('chicken')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [loading, failure] when SearchQueryChanged with valid query fails',
      build: () {
        when(mockSearchMeals('chicken')).thenThrow(Exception('API Error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('chicken')),
      expect: () => [
        const SearchState(
          status: SearchStatus.loading,
          query: 'chicken',
        ),
        const SearchState(
          status: SearchStatus.failure,
          errorMessage: 'Exception: API Error',
          query: 'chicken',
        ),
      ],
      verify: (_) {
        verify(mockSearchMeals('chicken')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [initial] when SearchCleared is added',
      build: () => bloc,
      seed: () => SearchState(
        status: SearchStatus.success,
        meals: testMeals,
        query: 'chicken',
      ),
      act: (bloc) => bloc.add(const SearchCleared()),
      expect: () => [const SearchState.initial()],
    );

    blocTest<SearchBloc, SearchState>(
      'trims whitespace from search query',
      build: () {
        when(mockSearchMeals('chicken')).thenAnswer((_) async => testMeals);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('  chicken  ')),
      expect: () => [
        const SearchState(
          status: SearchStatus.loading,
          query: 'chicken',
        ),
        SearchState(
          status: SearchStatus.success,
          meals: testMeals,
          query: 'chicken',
        ),
      ],
      verify: (_) {
        verify(mockSearchMeals('chicken')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'handles multiple search queries correctly',
      build: () {
        when(mockSearchMeals('chicken')).thenAnswer((_) async => testMeals);
        when(mockSearchMeals('pasta')).thenAnswer((_) async => [testMeals[0]]);
        return bloc;
      },
      act: (bloc) {
        bloc
          ..add(const SearchQueryChanged('chicken'))
          ..add(const SearchQueryChanged('pasta'));
      },
      expect: () => [
        const SearchState(
          status: SearchStatus.loading,
          query: 'chicken',
        ),
        SearchState(
          status: SearchStatus.success,
          meals: testMeals,
          query: 'chicken',
        ),
        const SearchState(
          status: SearchStatus.loading,
          query: 'pasta',
        ),
        SearchState(
          status: SearchStatus.success,
          meals: [testMeals[0]],
          query: 'pasta',
        ),
      ],
      verify: (_) {
        verify(mockSearchMeals('chicken')).called(1);
        verify(mockSearchMeals('pasta')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'handles search with special characters',
      build: () {
        when(mockSearchMeals('chicken & pasta')).thenAnswer((_) async => testMeals);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('chicken & pasta')),
      expect: () => [
        const SearchState(
          status: SearchStatus.loading,
          query: 'chicken & pasta',
        ),
        SearchState(
          status: SearchStatus.success,
          meals: testMeals,
          query: 'chicken & pasta',
        ),
      ],
      verify: (_) {
        verify(mockSearchMeals('chicken & pasta')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'handles search with numbers',
      build: () {
        when(mockSearchMeals('chicken123')).thenAnswer((_) async => testMeals);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('chicken123')),
      expect: () => [
        const SearchState(
          status: SearchStatus.loading,
          query: 'chicken123',
        ),
        SearchState(
          status: SearchStatus.success,
          meals: testMeals,
          query: 'chicken123',
        ),
      ],
      verify: (_) {
        verify(mockSearchMeals('chicken123')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'handles empty search results',
      build: () {
        when(mockSearchMeals('nonexistent')).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('nonexistent')),
      expect: () => [
        const SearchState(
          status: SearchStatus.loading,
          query: 'nonexistent',
        ),
        const SearchState(
          status: SearchStatus.success,
          query: 'nonexistent',
        ),
      ],
      verify: (_) {
        verify(mockSearchMeals('nonexistent')).called(1);
      },
    );
  });
}
