import 'package:atomberg_fan_controller/data/models/control_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:atomberg_fan_controller/data/repositories/device_repository_impl.dart';
import 'package:atomberg_fan_controller/data/services/api_service.dart';
import 'package:atomberg_fan_controller/data/services/storage_service.dart';
import 'package:atomberg_fan_controller/data/models/device_model.dart';

@GenerateMocks([ApiService, StorageService])
import 'device_repository_test.mocks.dart';

void main() {
  late DeviceRepositoryImpl repository;
  late MockApiService mockApiService;
  late MockStorageService mockStorageService;

  setUp(() {
    mockApiService = MockApiService();
    mockStorageService = MockStorageService();
    repository = DeviceRepositoryImpl(mockApiService, mockStorageService);
  });

  group('DeviceRepository', () {
    test('fetchDevices should return device entities', () async {
      // Arrange
      final mockDevices = [
        DeviceModel(
          id: '1',
          name: 'Test Fan',
          type: 'fan',
          isOnline: true,
          isPowerOn: false,
          speed: 1,
          isBreezeMode: false,
          isLightOn: false,
        )
      ];

      when(mockApiService.fetchDevices()).thenAnswer((_) async => mockDevices);
      when(mockStorageService.setString(any, any))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.fetchDevices();

      // Assert
      result.fold(
        onSuccess: (devices) {
          expect(devices.length, 1);
          expect(devices.first.name, 'Test Fan');
        },
        onFailure: (error) => fail('Should not fail'),
      );
    });

    test('controlPower should return success', () async {
      // Arrange
      when(mockApiService.controlPower(any, any)).thenAnswer(
        (_) async => ControlResponseModel(success: true, message: 'Success'),
      );

      // Act
      final result = await repository.controlPower('device1', true);

      // Assert
      result.fold(
        onSuccess: (success) => expect(success, true),
        onFailure: (error) => fail('Should not fail'),
      );
    });
  });
}
