import '../../core/constants/storage_keys.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final StorageService storageService;

  AuthRepositoryImpl(this.apiService, this.storageService);

  @override
  Future<Result<bool>> login(String apiKey, String refreshToken) async {
    try {
      // Save credentials
      await storageService.setString(StorageKeys.apiKey, apiKey);
      await storageService.setString(StorageKeys.refreshToken, refreshToken);

      // Validate by fetching devices
      await apiService.fetchDevices();

      // Mark as logged in
      await storageService.setBool(StorageKeys.isLoggedIn, true);

      return Result.success(true);
    } on AuthException catch (e) {
      await logout();
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      await logout();
      return Result.failure(e.message);
    } catch (e) {
      await logout();
      return Result.failure('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> logout() async {
    try {
      await storageService.remove(StorageKeys.apiKey);
      await storageService.remove(StorageKeys.refreshToken);
      await storageService.setBool(StorageKeys.isLoggedIn, false);
      await storageService.remove(StorageKeys.cachedDevices);

      return Result.success(true);
    } catch (e) {
      return Result.failure('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final isLoggedIn = await storageService.getBool(StorageKeys.isLoggedIn);
    final apiKey = await storageService.getString(StorageKeys.apiKey);
    return isLoggedIn == true && apiKey != null;
  }
}
