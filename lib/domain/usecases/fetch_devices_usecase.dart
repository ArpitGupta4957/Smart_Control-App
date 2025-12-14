import '../../core/utils/result.dart';
import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class FetchDevicesUseCase {
  final DeviceRepository repository;
  
  FetchDevicesUseCase(this.repository);
  
  Future<Result<List<DeviceEntity>>> execute() async {
    return await repository.fetchDevices();
  }
}