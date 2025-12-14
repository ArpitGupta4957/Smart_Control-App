import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:atomberg_fan_controller/domain/usecases/control_device_usecase.dart';
import 'package:atomberg_fan_controller/domain/repositories/device_repository.dart';
import 'package:atomberg_fan_controller/core/utils/result.dart';

@GenerateMocks([DeviceRepository])
import 'control_device_usecase_test.mocks.dart';

void main() {
  late ControlDeviceUseCase useCase;
  late MockDeviceRepository mockRepository;
  
  setUp(() {
    mockRepository = MockDeviceRepository();
    useCase = ControlDeviceUseCase(mockRepository);
  });
  
  group('ControlDeviceUseCase', () {
    test('should control power successfully', () async {
      // Arrange
      when(mockRepository.controlPower(any, any))
          .thenAnswer((_) async => Result.success(true));
      
      // Act
      final result = await useCase.execute(
        deviceId: 'device1',
        action: ControlAction.power,
        value: true,
      );
      
      // Assert
      result.fold(
        onSuccess: (success) => expect(success, true),
        onFailure: (error) => fail('Should not fail'),
      );
    });
    
    test('should validate speed range', () async {
      // Act
      final result = await useCase.execute(
        deviceId: 'device1',
        action: ControlAction.speed,
        value: 10,
      );
      
      // Assert
      result.fold(
        onSuccess: (_) => fail('Should fail validation'),
        onFailure: (error) => expect(error, contains('between 1 and 5')),
      );
    });
  });
}