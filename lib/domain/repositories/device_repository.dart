import '../../core/utils/result.dart';
import '../entities/device_entity.dart';

abstract class DeviceRepository {
  Future<Result<List<DeviceEntity>>> fetchDevices();
  Future<Result<DeviceEntity>> fetchDevice(String deviceId);
  Future<Result<bool>> controlPower(String deviceId, bool powerOn);
  Future<Result<bool>> controlSpeed(String deviceId, int speed);
  Future<Result<bool>> controlLight(String deviceId, bool lightOn);
  Future<Result<bool>> controlBreeze(String deviceId, bool breezeOn);
}