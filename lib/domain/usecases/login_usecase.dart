import '../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  Future<Result<bool>> execute(String apiKey, String refreshToken) async {
    if (apiKey.isEmpty || refreshToken.isEmpty) {
      return Result.failure('API Key and Refresh Token are required');
    }
    
    return await repository.login(apiKey, refreshToken);
  }
}