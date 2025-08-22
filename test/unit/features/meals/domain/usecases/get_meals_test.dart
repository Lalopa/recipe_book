import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';
import 'package:recipe_book/features/meals/domain/repositories/meal_repository.dart';
import 'package:recipe_book/features/meals/domain/usecases/get_meals.dart';

import 'get_meals_test.mocks.dart';

@GenerateMocks([MealRepository])
void main() {
  late GetMealsByLetter usecase;
  late MockMealRepository mockRepository;

  setUp(() {
    mockRepository = MockMealRepository();
    usecase = GetMealsByLetter(mockRepository);
  });

  const testMeals = [
    Meal(
      id: '1',
      name: 'Test Meal 1',
      thumbnail: 'https://example.com/image1.jpg',
      category: 'Test Category',
      instructions: 'Test instructions 1',
      ingredients: {'ingredient1': 'measure1'},
    ),
    Meal(
      id: '2',
      name: 'Test Meal 2',
      thumbnail: 'https://example.com/image2.jpg',
      category: 'Test Category',
      instructions: 'Test instructions 2',
      ingredients: {'ingredient2': 'measure2'},
    ),
  ];

  test('should get meals by letter from repository', () async {
    // arrange
    when(mockRepository.getMealsByLetter('a')).thenAnswer((_) async => testMeals);

    // act
    final result = await usecase('a');

    // assert
    expect(result, testMeals);
    verify(mockRepository.getMealsByLetter('a')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when repository returns empty list', () async {
    // arrange
    when(mockRepository.getMealsByLetter('z')).thenAnswer((_) async => <Meal>[]);

    // act
    final result = await usecase('z');

    // assert
    expect(result, isEmpty);
    verify(mockRepository.getMealsByLetter('z')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle repository errors', () async {
    // arrange
    when(mockRepository.getMealsByLetter('x')).thenThrow(Exception('Network error'));

    // act & assert
    expect(
      () => usecase('x'),
      throwsA(isA<Exception>()),
    );
    verify(mockRepository.getMealsByLetter('x')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
