import 'package:equatable/equatable.dart';

class UserCredentials extends Equatable {
  final String apiKey;
  final String refreshToken;
  
  const UserCredentials({
    required this.apiKey,
    required this.refreshToken,
  });
  
  @override
  List<Object> get props => [apiKey, refreshToken];
}