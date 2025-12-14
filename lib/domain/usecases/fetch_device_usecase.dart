import '../../core/utils/result.dart';
import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class FetchDeviceUseCase {
  final DeviceRepository repository;
  
  FetchDeviceUseCase(this.repository);
  
  Future<Result<DeviceEntity>> execute(String deviceId) async {
    if (deviceId.isEmpty) {
      return Result.failure('Device ID is required');
    }
    
    return await repository.fetchDevice(deviceId);
  }
}