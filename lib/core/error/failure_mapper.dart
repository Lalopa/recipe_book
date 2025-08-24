import 'package:dio/dio.dart';
import 'package:recipe_book/core/error/failures.dart';

/// Mapper to convert exceptions to specific Failure classes
class FailureMapper {
  const FailureMapper._();

  /// Converts an exception to an appropriate Failure class
  static Failure mapExceptionToFailure(dynamic exception) {
    if (exception is DioException) {
      return _mapDioExceptionToFailure(exception);
    }

    if (exception is FormatException) {
      return const ParsingFailure('Error processing data format');
    }

    if (exception is StateError) {
      return const LocalDatabaseFailure('Database state error');
    }

    if (exception is ArgumentError) {
      return const ValidationFailure('Invalid argument');
    }

    if (exception is RangeError) {
      return const ValidationFailure('Value out of allowed range');
    }

    if (exception is TypeError) {
      return const InvalidDataFailure('Incorrect data type');
    }

    // Fallback for unmapped exceptions
    return GenericFailure(exception.toString());
  }

  /// Maps specific Dio exceptions to Failure classes
  static Failure _mapDioExceptionToFailure(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.badResponse:
        return _mapHttpStatusToFailure(exception.response?.statusCode);

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badCertificate:
        return const NetworkFailure('SSL certificate error');

      case DioExceptionType.cancel:
        return const GenericFailure('Operation cancelled');

      case DioExceptionType.unknown:
        return const NetworkFailure('Unknown network error');
    }
  }

  /// Maps HTTP status codes to specific Failure classes
  static Failure _mapHttpStatusToFailure(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const InvalidDataFailure('Bad request');
      case 401:
        return const AuthenticationFailure('Unauthorized');
      case 403:
        return const UnauthorizedFailure('Access denied');
      case 404:
        return const NotFoundFailure();
      case 408:
        return const TimeoutFailure('Request timed out');
      case 422:
        return const ValidationFailure('Invalid input data');
      case 429:
        return const GenericFailure('Too many requests');
      case 500:
        return const ServerFailure('Internal server error');
      case 502:
        return const ServerFailure('Server unavailable');
      case 503:
        return const ServerFailure('Service unavailable');
      case 504:
        return const TimeoutFailure('Server response timeout');
      default:
        return const ServerFailure();
    }
  }

  /// Converts a custom error message to a Failure class
  static Failure mapMessageToFailure(String message, {FailureType type = FailureType.generic}) {
    switch (type) {
      case FailureType.network:
        return NetworkFailure(message);
      case FailureType.server:
        return ServerFailure(message);
      case FailureType.notFound:
        return NotFoundFailure(message);
      case FailureType.invalidData:
        return InvalidDataFailure(message);
      case FailureType.localDatabase:
        return LocalDatabaseFailure(message);
      case FailureType.cache:
        return CacheFailure(message);
      case FailureType.permission:
        return PermissionFailure(message);
      case FailureType.authentication:
        return AuthenticationFailure(message);
      case FailureType.unauthorized:
        return UnauthorizedFailure(message);
      case FailureType.timeout:
        return TimeoutFailure(message);
      case FailureType.file:
        return FileFailure(message);
      case FailureType.parsing:
        return ParsingFailure(message);
      case FailureType.validation:
        return ValidationFailure(message);
      case FailureType.search:
        return SearchFailure(message);
      case FailureType.favorite:
        return FavoriteFailure(message);
      case FailureType.generic:
        return GenericFailure(message);
    }
  }
}

enum FailureType {
  network,
  server,
  notFound,
  invalidData,
  localDatabase,
  cache,
  permission,
  authentication,
  unauthorized,
  timeout,
  file,
  parsing,
  validation,
  search,
  favorite,
  generic,
}
