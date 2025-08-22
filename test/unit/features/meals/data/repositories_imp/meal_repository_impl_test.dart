import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';
import 'package:recipe_book/features/meals/data/repositories_imp/meal_repository_impl.dart';
import 'package:recipe_book/features/meals/domain/entities/meal.dart';

import 'meal_repository_impl_test.mocks.dart';

@GenerateMocks([MealRemoteDataSource])
void main() {
  late MealRepositoryImpl repository;
  late MockMealRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockMealRemoteDataSource();
    repository = MealRepositoryImpl(mockRemoteDataSource);
  });

  final testMealModels = [
    const MealModel(
      id: '1',
      name: 'Test Meal 1',
      thumbnail: 'https://example.com/image1.jpg',
      category: 'Test Category',
      instructions: 'Test instructions 1',
      ingredients: {'ingredient1': 'measure1'},
    ),
    const MealModel(
      id: '2',
      name: 'Test Meal 2',
      thumbnail: 'https://example.com/image2.jpg',
      category: 'Test Category',
      instructions: 'Test instructions 2',
      ingredients: {'ingredient2': 'measure2'},
    ),
  ];

  final expectedMeals = [
    const Meal(
      id: '1',
      name: 'Test Meal 1',
      thumbnail: 'https://example.com/image1.jpg',
      category: 'Test Category',
      instructions: 'Test instructions 1',
      ingredients: {'ingredient1': 'measure1'},
    ),
    const Meal(
      id: '2',
      name: 'Test Meal 2',
      thumbnail: 'https://example.com/image2.jpg',
      category: 'Test Category',
      instructions: 'Test instructions 2',
      ingredients: {'ingredient2': 'measure2'},
    ),
  ];

  group('getMealsByLetter', () {
    test('should return meals when remote data source returns data', () async {
      // arrange
      when(mockRemoteDataSource.fetchByLetter('a')).thenAnswer((_) async => testMealModels);

      // act
      final result = await repository.getMealsByLetter('a');

      // assert
      expect(result, expectedMeals);
      verify(mockRemoteDataSource.fetchByLetter('a')).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return empty list when remote data source returns empty list', () async {
      // arrange
      when(mockRemoteDataSource.fetchByLetter('z')).thenAnswer((_) async => <MealModel>[]);

      // act
      final result = await repository.getMealsByLetter('z');

      // assert
      expect(result, isEmpty);
      verify(mockRemoteDataSource.fetchByLetter('z')).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should handle remote data source errors', () async {
      // arrange
      when(mockRemoteDataSource.fetchByLetter('x')).thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () => repository.getMealsByLetter('x'),
        throwsA(isA<Exception>()),
      );
      verify(mockRemoteDataSource.fetchByLetter('x')).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should convert MealModel to Meal entity correctly', () async {
      // arrange
      when(mockRemoteDataSource.fetchByLetter('a')).thenAnswer((_) async => testMealModels);

      // act
      final result = await repository.getMealsByLetter('a');

      // assert
      expect(result.length, 2);
      expect(result[0], isA<Meal>());
      expect(result[0].id, '1');
      expect(result[0].name, 'Test Meal 1');
      expect(result[1].id, '2');
      expect(result[1].name, 'Test Meal 2');
    });
  });
}
