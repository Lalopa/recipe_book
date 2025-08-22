import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book/features/meals/data/datasources/meal_rest_provider.dart';
import 'package:recipe_book/features/meals/data/models/meal_model.dart';

import 'meal_rest_provider_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MealRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = MealRemoteDataSourceImpl(mockDio);
  });

  group('fetchByLetter', () {
    test('should return meals when API call is successful', () async {
      // arrange
      final responseData = {
        'meals': [
          {
            'idMeal': '1',
            'strMeal': 'Test Meal 1',
            'strMealThumb': 'https://example.com/image1.jpg',
            'strCategory': 'Test Category',
            'strInstructions': 'Test instructions 1',
            'strIngredient1': 'ingredient1',
            'strMeasure1': 'measure1',
          },
          {
            'idMeal': '2',
            'strMeal': 'Test Meal 2',
            'strMealThumb': 'https://example.com/image2.jpg',
            'strCategory': 'Test Category',
            'strInstructions': 'Test instructions 2',
            'strIngredient2': 'ingredient2',
            'strMeasure2': 'measure2',
          },
        ],
      };

      final response = Response<Map<String, dynamic>>(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/test'),
      );

      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer((_) async => response);

      // act
      final result = await dataSource.fetchByLetter('a');

      // assert
      expect(result, isA<List<MealModel>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].name, 'Test Meal 1');
      expect(result[1].id, '2');
      expect(result[1].name, 'Test Meal 2');

      verify(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: {'f': 'a'},
        ),
      ).called(1);
    });

    test('should return empty list when API returns no meals', () async {
      // arrange
      final responseData = {'meals': null};

      final response = Response<Map<String, dynamic>>(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/test'),
      );

      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer((_) async => response);

      // act
      final result = await dataSource.fetchByLetter('z');

      // assert
      expect(result, isEmpty);

      verify(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: {'f': 'z'},
        ),
      ).called(1);
    });

    test('should return empty list when API returns empty meals array', () async {
      // arrange
      final responseData = {'meals': <Map<String, dynamic>>[]};

      final response = Response<Map<String, dynamic>>(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/test'),
      );

      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer((_) async => response);

      // act
      final result = await dataSource.fetchByLetter('x');

      // assert
      expect(result, isEmpty);

      verify(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: {'f': 'x'},
        ),
      ).called(1);
    });

    test('should handle API errors', () async {
      // arrange
      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: 'Network error',
        ),
      );

      // act & assert
      expect(
        () => dataSource.fetchByLetter('a'),
        throwsA(isA<DioException>()),
      );

      verify(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: {'f': 'a'},
        ),
      ).called(1);
    });

    test('should handle malformed response data', () async {
      // arrange
      final responseData = {'meals': 'invalid_data'};

      final response = Response<Map<String, dynamic>>(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/test'),
      );

      when(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: anyNamed('queryParameters'),
        ),
      ).thenAnswer((_) async => response);

      // act & assert
      expect(
        () => dataSource.fetchByLetter('a'),
        throwsA(isA<TypeError>()),
      );

      verify(
        mockDio.get<Map<String, dynamic>>(
          any,
          queryParameters: {'f': 'a'},
        ),
      ).called(1);
    });
  });
}
