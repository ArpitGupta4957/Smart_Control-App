import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection']) 
      : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) 
      : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed']) 
      : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Device not found']) 
      : super(message);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([String message = 'Too many requests']) 
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) 
      : super(message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'Unexpected error occurred']) 
      : super(message);
}