import 'dart:convert';
import '../../core/constants/storage_keys.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../models/device_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final ApiService apiService;
  final StorageService storageService;

  DeviceRepositoryImpl(this.apiService, this.storageService);

  @override
  Future<Result<List<DeviceEntity>>> fetchDevices() async {
    try {
      final devices = await apiService.fetchDevices();
      final entities = devices.map((model) => model.toEntity()).toList();

      // Cache devices
      await _cacheDevices(devices);

      return Result.success(entities);
    } on NetworkException catch (e) {
      // Return cached devices if available
      final cachedDevices = await _getCachedDevices();
      if (cachedDevices.isNotEmpty) {
        return Result.success(cachedDevices);
      }
      return Result.failure(e.message);
    } catch (e) {
      // Return cached devices if available
      final cachedDevices = await _getCachedDevices();
      if (cachedDevices.isNotEmpty) {
        return Result.success(cachedDevices);
      }
      return Result.failure('Failed to fetch devices: ${e.toString()}');
    }
  }

  @override
  Future<Result<DeviceEntity>> fetchDevice(String deviceId) async {
    try {
      final device = await apiService.fetchDevice(deviceId);
      return Result.success(device.toEntity());
    } catch (e) {
      return Result.failure('Failed to fetch device: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> controlPower(String deviceId, bool powerOn) async {
    try {
      final response = await apiService.controlPower(deviceId, powerOn);
      return Result.success(response.success);
    } catch (e) {
      return Result.failure('Failed to control power: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> controlSpeed(String deviceId, int speed) async {
    try {
      final response = await apiService.controlSpeed(deviceId, speed);
      return Result.success(response.success);
    } catch (e) {
      return Result.failure('Failed to control speed: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> controlLight(String deviceId, bool lightOn) async {
    try {
      final response = await apiService.controlLight(deviceId, lightOn);
      return Result.success(response.success);
    } catch (e) {
      return Result.failure('Failed to control light: ${e.toString()}');
    }
  }

  @override
  Future<Result<bool>> controlBreeze(String deviceId, bool breezeOn) async {
    try {
      final response = await apiService.controlBreeze(deviceId, breezeOn);
      return Result.success(response.success);
    } catch (e) {
      return Result.failure('Failed to control breeze mode: ${e.toString()}');
    }
  }

  // Cache management
  Future<void> _cacheDevices(List<DeviceModel> devices) async {
    final jsonList = devices.map((d) => d.toJson()).toList();
    await storageService.setString(
      StorageKeys.cachedDevices,
      jsonEncode(jsonList),
    );
  }

  Future<List<DeviceEntity>> _getCachedDevices() async {
    final cached = await storageService.getString(StorageKeys.cachedDevices);
    if (cached != null) {
      final List<dynamic> jsonList = jsonDecode(cached);
      return jsonList
          .map((json) => DeviceModel.fromJson(json).toEntity())
          .toList();
    }
    return [];
  }
}
