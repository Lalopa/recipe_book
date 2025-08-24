import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/core/error/failures.dart';
import 'package:recipe_book/core/utils/api_constants.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_rest_provider.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

import 'meal_rest_provider_test.mocks.dart';

// Helper para crear MealModel de prueba
MealModel buildTestMealModel({
  required String id,
  required String name,
  String? thumbnail,
  String? category,
  String? instructions,
  Map<String, String>? ingredients,
}) {
  return MealModel(
    id: id,
    name: name,
    thumbnail: thumbnail ?? 'https://example.com/$id.jpg',
    category: category ?? 'Category $id',
    instructions: instructions ?? 'Instructions for $name',
    ingredients: ingredients ?? {'ingredient1': 'amount1'},
  );
}

@GenerateMocks([Dio])
void main() {
  group('MealRemoteDataSourceImpl', () {
    late MealRemoteDataSourceImpl dataSource;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      dataSource = MealRemoteDataSourceImpl(mockDio);
    });

    group('fetchByLetter', () {
      test('should return meals when API call succeeds', () async {
        // arrange
        const letter = 'a';
        final responseData = {
          'meals': [
            {
              'idMeal': '1',
              'strMeal': 'Apple Pie',
              'strMealThumb': 'https://example.com/apple.jpg',
              'strCategory': 'Dessert',
              'strInstructions': 'Make apple pie',
              'strIngredient1': 'Apples',
              'strMeasure1': '4 cups',
            },
            {
              'idMeal': '2',
              'strMeal': 'Avocado Salad',
              'strMealThumb': 'https://example.com/avocado.jpg',
              'strCategory': 'Salad',
              'strInstructions': 'Make avocado salad',
              'strIngredient1': 'Avocado',
              'strMeasure1': '2 pieces',
            },
          ],
        };

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.fetchByLetter(letter);

        // assert
        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].name, 'Apple Pie');
        expect(result[1].id, '2');
        expect(result[1].name, 'Avocado Salad');

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should return empty list when API returns no meals', () async {
        // arrange
        const letter = 'x';
        final responseData = {'meals': null};

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.fetchByLetter(letter);

        // assert
        expect(result, isEmpty);

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should return empty list when API returns empty meals array', () async {
        // arrange
        const letter = 'z';
        final responseData = {'meals': <Map<String, dynamic>>[]};

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.fetchByLetter(letter);

        // assert
        expect(result, isEmpty);

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should handle API errors', () async {
        // arrange
        const letter = 'a';
        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        // act & assert
        expect(
          () => dataSource.fetchByLetter(letter),
          throwsA(isA<NetworkFailure>()),
        );

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'f': letter},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });
    });

    group('searchMeals', () {
      test('should return meals when API call succeeds', () async {
        // arrange
        const query = 'chicken';
        final responseData = {
          'meals': [
            {
              'idMeal': '1',
              'strMeal': 'Chicken Pasta',
              'strMealThumb': 'https://example.com/chicken.jpg',
              'strCategory': 'Main Course',
              'strInstructions': 'Make chicken pasta',
              'strIngredient1': 'Chicken',
              'strMeasure1': '500g',
            },
            {
              'idMeal': '2',
              'strMeal': 'Chicken Salad',
              'strMealThumb': 'https://example.com/salad.jpg',
              'strCategory': 'Salad',
              'strInstructions': 'Make chicken salad',
              'strIngredient1': 'Chicken',
              'strMeasure1': '300g',
            },
          ],
        };

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.searchMeals(query);

        // assert
        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].name, 'Chicken Pasta');
        expect(result[1].id, '2');
        expect(result[1].name, 'Chicken Salad');

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should return empty list when API returns no meals', () async {
        // arrange
        const query = 'nonexistent';
        final responseData = {'meals': null};

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.searchMeals(query);

        // assert
        expect(result, isEmpty);

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should return empty list when API returns empty meals array', () async {
        // arrange
        const query = 'xyz123';
        final responseData = {'meals': <Map<String, dynamic>>[]};

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.searchMeals(query);

        // assert
        expect(result, isEmpty);

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should handle API errors', () async {
        // arrange
        const query = 'chicken';
        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(),
            ),
          ),
        );

        // act & assert
        expect(
          () => dataSource.searchMeals(query),
          throwsA(isA<NetworkFailure>()),
        );

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should search with different queries', () async {
        // arrange
        const query1 = 'chicken';
        const query2 = 'pasta';
        final responseData1 = {
          'meals': [
            {
              'idMeal': '1',
              'strMeal': 'Chicken Pasta',
              'strMealThumb': 'https://example.com/chicken.jpg',
              'strCategory': 'Main Course',
              'strInstructions': 'Make chicken pasta',
              'strIngredient1': 'Chicken',
              'strMeasure1': '500g',
            },
          ],
        };
        final responseData2 = {
          'meals': [
            {
              'idMeal': '2',
              'strMeal': 'Pasta Carbonara',
              'strMealThumb': 'https://example.com/pasta.jpg',
              'strCategory': 'Main Course',
              'strInstructions': 'Make pasta carbonara',
              'strIngredient1': 'Pasta',
              'strMeasure1': '400g',
            },
          ],
        };

        final response1 = Response<Map<String, dynamic>>(
          data: responseData1,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );
        final response2 = Response<Map<String, dynamic>>(
          data: responseData2,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query1},
          ),
        ).thenAnswer((_) async => response1);
        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query2},
          ),
        ).thenAnswer((_) async => response2);

        // act
        final result1 = await dataSource.searchMeals(query1);
        final result2 = await dataSource.searchMeals(query2);

        // assert
        expect(result1.length, 1);
        expect(result1[0].name, 'Chicken Pasta');
        expect(result2.length, 1);
        expect(result2[0].name, 'Pasta Carbonara');

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query1},
          ),
        ).called(1);
        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query2},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should search with special characters in query', () async {
        // arrange
        const query = 'chicken & pasta';
        final responseData = {
          'meals': [
            {
              'idMeal': '1',
              'strMeal': 'Chicken & Pasta',
              'strMealThumb': 'https://example.com/chicken-pasta.jpg',
              'strCategory': 'Main Course',
              'strInstructions': 'Make chicken & pasta',
              'strIngredient1': 'Chicken',
              'strMeasure1': '500g',
            },
          ],
        };

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.searchMeals(query);

        // assert
        expect(result.length, 1);
        expect(result[0].name, 'Chicken & Pasta');

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should search with numbers in query', () async {
        // arrange
        const query = 'chicken123';
        final responseData = {
          'meals': [
            {
              'idMeal': '1',
              'strMeal': 'Chicken123',
              'strMealThumb': 'https://example.com/chicken123.jpg',
              'strCategory': 'Main Course',
              'strInstructions': 'Make chicken123',
              'strIngredient1': 'Chicken',
              'strMeasure1': '500g',
            },
          ],
        };

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.searchMeals(query);

        // assert
        expect(result.length, 1);
        expect(result[0].name, 'Chicken123');

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });

      test('should search with empty query', () async {
        // arrange
        const query = '';
        final responseData = {'meals': <Map<String, dynamic>>[]};

        final response = Response<Map<String, dynamic>>(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        );

        when(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).thenAnswer((_) async => response);

        // act
        final result = await dataSource.searchMeals(query);

        // assert
        expect(result, isEmpty);

        verify(
          mockDio.get<Map<String, dynamic>>(
            ApiConstants.search,
            queryParameters: {'s': query},
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDio);
      });
    });
  });
}
