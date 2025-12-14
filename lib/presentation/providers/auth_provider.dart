import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import '../../data/services/storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final StorageService storageService;

  AuthState _state = AuthState.initial;
  String? _errorMessage;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  AuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.storageService,
  });

  Future<void> checkAuthStatus() async {
    _state = AuthState.loading;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final apiKey = await storageService.getString('api_key');
      final isLoggedIn = await storageService.getBool('is_logged_in');

      if (apiKey != null && isLoggedIn == true) {
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
      }
    } catch (e) {
      _state = AuthState.unauthenticated;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<bool> login(String apiKey, String refreshToken) async {
    _state = AuthState.loading;
    _errorMessage = null;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final result = await loginUseCase.execute(apiKey, refreshToken);

    return result.fold(
      onSuccess: (success) {
        _state = AuthState.authenticated;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        return true;
      },
      onFailure: (error) {
        _state = AuthState.error;
        _errorMessage = error;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        return false;
      },
    );
  }

  Future<void> logout() async {
    _state = AuthState.loading;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    await logoutUseCase.execute();

    _state = AuthState.unauthenticated;
    _errorMessage = null;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
