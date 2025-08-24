/// Class to handle consistent error messages throughout the application
class ErrorMessages {
  const ErrorMessages._();

  // Network messages
  static const String networkError = 'Network connection error';
  static const String networkTimeout = 'Operation timed out';
  static const String networkUnavailable = 'Network unavailable';
  static const String sslError = 'SSL certificate error';

  // Server messages
  static const String serverError = 'Server error';
  static const String serverUnavailable = 'Server unavailable';
  static const String serviceUnavailable = 'Service unavailable';
  static const String tooManyRequests = 'Too many requests';

  // Data messages
  static const String dataNotFound = 'Data not found';
  static const String invalidData = 'Invalid data';
  static const String parsingError = 'Error processing data';
  static const String validationError = 'Validation error';

  // Local database messages
  static const String databaseError = 'Local database error';
  static const String databaseNotInitialized = 'Database not initialized';
  static const String cacheError = 'Cache error';

  // Authentication messages
  static const String authenticationError = 'Authentication error';
  static const String unauthorized = 'Access denied';
  static const String permissionDenied = 'Insufficient permissions';

  // File messages
  static const String fileError = 'File error';
  static const String fileNotFound = 'File not found';
  static const String fileCorrupted = 'File corrupted';

  // Search messages
  static const String searchError = 'Search error';
  static const String searchNoResults = 'No results found';
  static const String searchInvalidQuery = 'Invalid search query';

  // Favorite messages
  static const String favoriteError = 'Favorite operation error';
  static const String favoriteAddError = 'Error adding to favorites';
  static const String favoriteRemoveError = 'Error removing from favorites';

  // Generic messages
  static const String unexpectedError = 'Unexpected error';
  static const String operationCancelled = 'Operation cancelled';
  static const String operationFailed = 'Operation failed';
  static const String tryAgainLater = 'Try again later';

  // User-friendly messages
  static const String userFriendlyNetworkError =
      "It seems there's a problem with your connection. Check your internet and try again.";
  static const String userFriendlyServerError = "We're experiencing technical issues. Please try again later.";
  static const String userFriendlyDataError = "The data couldn't be loaded correctly. Please try again.";
  static const String userFriendlyGenericError = 'Something went wrong. Please try again.';

  /// Gets a user-friendly error message based on the failure type
  static String getUserFriendlyMessage(String failureMessage) {
    if (failureMessage.contains('network') || failureMessage.contains('connection')) {
      return userFriendlyNetworkError;
    }

    if (failureMessage.contains('server')) {
      return userFriendlyServerError;
    }

    if (failureMessage.contains('data') || failureMessage.contains('processing')) {
      return userFriendlyDataError;
    }

    return userFriendlyGenericError;
  }

  /// Gets an error message for logging based on the failure type
  static String getLogMessage(String failureMessage, {String? context}) {
    final timestamp = DateTime.now().toIso8601String();
    final contextInfo = context != null ? 'Context: $context' : '';

    return '[$timestamp] Error: $failureMessage $contextInfo'.trim();
  }
}
