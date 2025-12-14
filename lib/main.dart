import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/network/dio_client.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/device_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/fetch_devices_usecase.dart';
import 'domain/usecases/fetch_device_usecase.dart';
import 'domain/usecases/control_device_usecase.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/device_provider.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Initialize services
  final storageService = StorageService();
  await storageService.init();
  
  final dioClient = DioClient(storageService);
  final apiService = ApiService(dioClient.dio);
  
  // Initialize repositories
  final authRepository = AuthRepositoryImpl(apiService, storageService);
  final deviceRepository = DeviceRepositoryImpl(apiService, storageService);
  
  // Initialize use cases
  final loginUseCase = LoginUseCase(authRepository);
  final logoutUseCase = LogoutUseCase(authRepository);
  final fetchDevicesUseCase = FetchDevicesUseCase(deviceRepository);
  final fetchDeviceUseCase = FetchDeviceUseCase(deviceRepository);
  final controlDeviceUseCase = ControlDeviceUseCase(deviceRepository);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: loginUseCase,
            logoutUseCase: logoutUseCase,
            storageService: storageService,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, DeviceProvider>(
          create: (_) => DeviceProvider(
            fetchDevicesUseCase: fetchDevicesUseCase,
            fetchDeviceUseCase: fetchDeviceUseCase,
            controlDeviceUseCase: controlDeviceUseCase,
          ),
          update: (_, auth, previous) => previous ?? DeviceProvider(
            fetchDevicesUseCase: fetchDevicesUseCase,
            fetchDeviceUseCase: fetchDeviceUseCase,
            controlDeviceUseCase: controlDeviceUseCase,
          ),
        ),
      ],
      child: const AtombergApp(),
    ),
  );
}