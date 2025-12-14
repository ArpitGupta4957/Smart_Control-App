class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException(this.message, [this.code]);
  
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([String? message]) 
      : super(message ?? 'No internet connection');
}

class ServerException extends AppException {
  ServerException([String? message]) 
      : super(message ?? 'Server error occurred');
}

class AuthException extends AppException {
  AuthException([String? message]) 
      : super(message ?? 'Authentication failed');
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) 
      : super(message ?? 'Resource not found');
}

class RateLimitException extends AppException {
  RateLimitException([String? message]) 
      : super(message ?? 'Too many requests. Please try again later');
}

class UnexpectedException extends AppException {
  UnexpectedException([String? message]) 
      : super(message ?? 'An unexpected error occurred');
}