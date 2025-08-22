import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';
import 'package:recipe_book/features/meals/presentation/bloc/meal_bloc.dart';

import 'meal_bloc_test.mocks.dart';

// Helper para crear MealState de prueba
MealState buildMealState({
  MealStatus status = MealStatus.loading,
  List<Meal> meals = const [],
  int letterIndex = 0,
  int offsetInLetter = 0,
  bool hasReachedMax = false,
  String searchQuery = '',
  List<Meal> searchResults = const [],
}) {
  return MealState(
    status: status,
    meals: meals,
    letterIndex: letterIndex,
    offsetInLetter: offsetInLetter,
    hasReachedMax: hasReachedMax,
    searchQuery: searchQuery,
    searchResults: searchResults,
  );
}

// Helper para crear Meal de prueba
Meal buildTestMeal({
  required String letter,
  required int index,
  String? id,
  String? name,
  String? thumbnail,
  String? category,
  String? instructions,
  Map<String, String>? ingredients,
}) {
  return Meal(
    id: id ?? '${letter}_$index',
    name: name ?? '${letter.toUpperCase()} Meal $index',
    thumbnail: thumbnail ?? 'https://example.com/${letter}_$index.jpg',
    category: category ?? 'Category ${letter.toUpperCase()}',
    instructions: instructions ?? 'Instructions for ${letter.toUpperCase()} meal $index',
    ingredients: ingredients ?? {'ingredient_$index': '$index cup'},
  );
}

// Helper para configurar mocks con solo la primera letra retornando comidas
void setupMockWithFirstLetterOnly(MockGetMealsByLetter mock, List<Meal> meals) {
  when(mock('a')).thenAnswer((_) async => meals);
  // Configure stubs for other letters to return empty lists
  for (var i = 1; i < 26; i++) {
    final letter = String.fromCharCode(97 + i);
    when(mock(letter)).thenAnswer((_) async => <Meal>[]);
  }
}

// Helper para configurar mocks con las primeras dos letras retornando comidas
void setupMockWithFirstTwoLetters(MockGetMealsByLetter mock, List<Meal> firstMeals, List<Meal> secondMeals) {
  when(mock('a')).thenAnswer((_) async => firstMeals);
  when(mock('b')).thenAnswer((_) async => secondMeals);
  // Configure stubs for other letters to return empty lists
  for (var i = 2; i < 26; i++) {
    final letter = String.fromCharCode(97 + i);
    when(mock(letter)).thenAnswer((_) async => <Meal>[]);
  }
}

// Helper para configurar mocks con todas las letras retornando comidas
void setupMockWithAllLetters(MockGetMealsByLetter mock, {int mealsPerLetter = 4}) {
  for (var i = 0; i < 26; i++) {
    final letter = String.fromCharCode(97 + i);
    final mealsForLetter = List.generate(
      mealsPerLetter,
      (index) => buildTestMeal(letter: letter, index: index + 1),
    );
    when(mock(letter)).thenAnswer((_) async => mealsForLetter);
  }
}

// Helper para configurar mock con error
void setupMockWithError(MockGetMealsByLetter mock, Exception error) {
  when(mock('a')).thenThrow(error);
}

// Datos de prueba
final List<Meal> testMeals = [
  buildTestMeal(letter: 'a', index: 1),
  buildTestMeal(letter: 'a', index: 2),
  buildTestMeal(letter: 'a', index: 3),
];

final List<Meal> moreTestMeals = [
  buildTestMeal(letter: 'b', index: 1),
  buildTestMeal(letter: 'b', index: 2),
  buildTestMeal(letter: 'b', index: 3),
];

@GenerateMocks([GetMealsByLetter])
void main() {
  late MealBloc bloc;
  late MockGetMealsByLetter mockGetMealsByLetter;

  setUp(() {
    mockGetMealsByLetter = MockGetMealsByLetter();
    bloc = MealBloc(mockGetMealsByLetter);
  });

  tearDown(() {
    bloc.close();
  });

  group('MealBloc', () {
    test('initial state should be MealState.initial', () {
      expect(bloc.state, buildMealState(status: MealStatus.initial));
    });

    blocTest<MealBloc, MealState>(
      'emits [loading, success] when MealFetched is added and succeeds',
      build: () {
        setupMockWithFirstLetterOnly(mockGetMealsByLetter, testMeals);
        return bloc;
      },
      act: (bloc) => bloc.add(const MealFetched()),
      expect: () => [
        buildMealState(),
        buildMealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 26,
        ),
      ],
      verify: (_) {
        verify(mockGetMealsByLetter('a')).called(1);
      },
    );

    blocTest<MealBloc, MealState>(
      'emits [loading, success] when MealFetched is added with pagination',
      build: () {
        setupMockWithFirstTwoLetters(mockGetMealsByLetter, testMeals, moreTestMeals);
        return bloc;
      },
      act: (bloc) => bloc.add(const MealFetched()),
      expect: () => [
        buildMealState(),
        buildMealState(
          status: MealStatus.success,
          meals: [...testMeals, ...moreTestMeals],
          letterIndex: 26,
        ),
      ],
      verify: (_) {
        verify(mockGetMealsByLetter('a')).called(1);
        verify(mockGetMealsByLetter('b')).called(1);
      },
    );

    blocTest<MealBloc, MealState>(
      'emits [loading, success] when MealFetched is added and reaches max',
      build: () {
        setupMockWithFirstLetterOnly(mockGetMealsByLetter, testMeals);
        return bloc;
      },
      act: (bloc) => bloc.add(const MealFetched()),
      expect: () => [
        buildMealState(),
        buildMealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 26,
        ),
      ],
    );

    blocTest<MealBloc, MealState>(
      'does not emit new states when MealFetched is added while loading',
      build: () => bloc,
      seed: buildMealState,
      act: (bloc) => bloc.add(const MealFetched()),
      expect: () => <MealState>[],
    );

    blocTest<MealBloc, MealState>(
      'does not emit new states when MealFetched is added and has reached max',
      build: () => bloc,
      seed: () => buildMealState(
        status: MealStatus.success,
        meals: testMeals,
        letterIndex: 26,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const MealFetched()),
      expect: () => <MealState>[],
    );

    blocTest<MealBloc, MealState>(
      'emits [initial] when MealRefreshed is added',
      build: () {
        setupMockWithFirstLetterOnly(mockGetMealsByLetter, testMeals);
        return bloc;
      },
      seed: () => buildMealState(
        status: MealStatus.success,
        meals: testMeals,
        letterIndex: 1,
      ),
      act: (bloc) => bloc.add(const MealRefreshed()),
      expect: () => [
        buildMealState(status: MealStatus.initial),
        buildMealState(),
        buildMealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 26,
        ),
      ],
    );

    blocTest<MealBloc, MealState>(
      'clears cache when MealRefreshed is added',
      build: () {
        setupMockWithFirstLetterOnly(mockGetMealsByLetter, testMeals);
        return bloc;
      },
      seed: () => buildMealState(
        status: MealStatus.success,
        meals: testMeals,
        letterIndex: 1,
      ),
      act: (bloc) => bloc.add(const MealRefreshed()),
      expect: () => [
        buildMealState(status: MealStatus.initial),
        buildMealState(),
        buildMealState(
          status: MealStatus.success,
          meals: testMeals,
          letterIndex: 26,
        ),
      ],
      verify: (_) {
        // After refresh, the cache should be cleared and new calls should be made
        verify(mockGetMealsByLetter('a')).called(1);
      },
    );

    blocTest<MealBloc, MealState>(
      'should handle meals from multiple letters',
      build: () {
        setupMockWithAllLetters(mockGetMealsByLetter);
        return bloc;
      },
      act: (bloc) => bloc.add(const MealFetched()),
      expect: () {
        final expectedMeals = [
          ...List.generate(4, (i) => buildTestMeal(letter: 'a', index: i + 1)),
          ...List.generate(4, (i) => buildTestMeal(letter: 'b', index: i + 1)),
          ...List.generate(4, (i) => buildTestMeal(letter: 'c', index: i + 1)),
        ];

        return [
          buildMealState(),
          buildMealState(
            status: MealStatus.success,
            meals: expectedMeals,
            letterIndex: 3,
          ),
        ];
      },
      verify: (_) {
        // Verify that the first 3 letters were called (to get 12 meals)
        verify(mockGetMealsByLetter('a')).called(1);
        verify(mockGetMealsByLetter('b')).called(1);
        verify(mockGetMealsByLetter('c')).called(1);
      },
    );

    blocTest<MealBloc, MealState>(
      'should handle API errors gracefully',
      build: () {
        setupMockWithError(mockGetMealsByLetter, Exception('API Error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const MealFetched()),
      expect: () => [
        buildMealState(),
        buildMealState(status: MealStatus.failure),
      ],
    );
  });
}
