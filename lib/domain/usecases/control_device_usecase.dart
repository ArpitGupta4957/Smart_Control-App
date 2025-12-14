import '../../core/utils/result.dart';
import '../repositories/device_repository.dart';

enum ControlAction {
  power,
  speed,
  light,
  breeze,
}

class ControlDeviceUseCase {
  final DeviceRepository repository;
  
  ControlDeviceUseCase(this.repository);
  
  Future<Result<bool>> execute({
    required String deviceId,
    required ControlAction action,
    dynamic value,
  }) async {
    if (deviceId.isEmpty) {
      return Result.failure('Device ID is required');
    }
    
    switch (action) {
      case ControlAction.power:
        if (value is! bool) {
          return Result.failure('Invalid power value');
        }
        return await repository.controlPower(deviceId, value);
        
      case ControlAction.speed:
        if (value is! int) {
          return Result.failure('Invalid speed value');
        }
        if (value < 1 || value > 5) {
          return Result.failure('Speed must be between 1 and 5');
        }
        return await repository.controlSpeed(deviceId, value);
        
      case ControlAction.light:
        if (value is! bool) {
          return Result.failure('Invalid light value');
        }
        return await repository.controlLight(deviceId, value);
        
      case ControlAction.breeze:
        if (value is! bool) {
          return Result.failure('Invalid breeze value');
        }
        return await repository.controlBreeze(deviceId, value);
    }
  }
}