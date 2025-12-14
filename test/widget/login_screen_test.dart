import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:atomberg_fan_controller/presentation/screens/login_screen.dart';
import 'package:atomberg_fan_controller/presentation/providers/auth_provider.dart';
import 'package:atomberg_fan_controller/domain/usecases/login_usecase.dart';
import 'package:atomberg_fan_controller/domain/usecases/logout_usecase.dart';
import 'package:atomberg_fan_controller/data/services/storage_service.dart';

@GenerateMocks([LoginUseCase, LogoutUseCase, StorageService])
import 'login_screen_test.mocks.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockStorageService mockStorageService;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockStorageService = MockStorageService();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => AuthProvider(
          loginUseCase: mockLoginUseCase,
          logoutUseCase: mockLogoutUseCase,
          storageService: mockStorageService,
        ),
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('should display login form', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Atomberg Fan Controller'), findsOneWidget);
      expect(find.text('API Key'), findsOneWidget);
      expect(find.text('Refresh Token'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should show error for empty fields', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('API Key is required'), findsOneWidget);
      expect(find.text('Refresh Token is required'), findsOneWidget);
    });
  });
}
