import '../../core/utils/result.dart';

abstract class AuthRepository {
  Future<Result<bool>> login(String apiKey, String refreshToken);
  Future<Result<bool>> logout();
  Future<bool> isLoggedIn();
}