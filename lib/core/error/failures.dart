import 'package:equatable/equatable.dart';

/// Base abstract class for all failure types in the application
abstract class Failure extends Equatable implements Exception {
  const Failure([this.message = '']);

  final String message;

  @override
  List<Object> get props => [message];
}

/// Failure related to network operations
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection error']);
}

/// Failure related to server operations
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

/// Failure related to data not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Failure related to invalid data
class InvalidDataFailure extends Failure {
  const InvalidDataFailure([super.message = 'Invalid data']);
}

/// Failure related to local database operations
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure([super.message = 'Local database error']);
}

/// Failure related to cache operations
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

/// Failure related to permissions
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Insufficient permissions']);
}

/// Failure related to authentication
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication error']);
}

/// Failure related to unauthorized operations
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized operation']);
}

/// Failure related to timeouts
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Operation timed out']);
}

/// Failure related to file operations
class FileFailure extends Failure {
  const FileFailure([super.message = 'File error']);
}

/// Failure related to parsing operations
class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Data parsing error']);
}

/// Failure related to validation operations
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

/// Failure related to search operations
class SearchFailure extends Failure {
  const SearchFailure([super.message = 'Search error']);
}

/// Failure related to favorite operations
class FavoriteFailure extends Failure {
  const FavoriteFailure([super.message = 'Favorite operation error']);
}

/// Generic failure for uncategorized errors
class GenericFailure extends Failure {
  const GenericFailure([super.message = 'Unexpected error']);
}
