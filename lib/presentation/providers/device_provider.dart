import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/usecases/fetch_devices_usecase.dart';
import '../../domain/usecases/fetch_device_usecase.dart';
import '../../domain/usecases/control_device_usecase.dart';

enum DeviceListState { initial, loading, loaded, error, offline }

class DeviceProvider with ChangeNotifier {
  final FetchDevicesUseCase fetchDevicesUseCase;
  final FetchDeviceUseCase fetchDeviceUseCase;
  final ControlDeviceUseCase controlDeviceUseCase;
  
  DeviceListState _state = DeviceListState.initial;
  List<DeviceEntity> _devices = [];
  String? _errorMessage;
  Timer? _refreshTimer;
  bool _isOffline = false;
  
  DeviceListState get state => _state;
  List<DeviceEntity> get devices => _devices;
  String? get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  bool get isLoading => _state == DeviceListState.loading;
  
  DeviceProvider({
    required this.fetchDevicesUseCase,
    required this.fetchDeviceUseCase,
    required this.controlDeviceUseCase,
  });
  
  Future<void> fetchDevices({bool showLoading = true}) async {
    if (showLoading) {
      _state = DeviceListState.loading;
      notifyListeners();
    }
    
    final result = await fetchDevicesUseCase.execute();
    
    result.fold(
      onSuccess: (devices) {
        _devices = devices;
        _state = DeviceListState.loaded;
        _isOffline = false;
        _errorMessage = null;
      },
      onFailure: (error) {
        if (error.contains('connection') || error.contains('network')) {
          _isOffline = true;
          if (_devices.isEmpty) {
            _state = DeviceListState.offline;
          } else {
            _state = DeviceListState.loaded;
          }
        } else {
          _state = DeviceListState.error;
        }
        _errorMessage = error;
      },
    );
    
    notifyListeners();
  }
  
  Future<DeviceEntity?> fetchDevice(String deviceId) async {
    final result = await fetchDeviceUseCase.execute(deviceId);
    
    return result.fold(
      onSuccess: (device) {
        // Update device in list
        final index = _devices.indexWhere((d) => d.id == device.id);
        if (index != -1) {
          _devices[index] = device;
          notifyListeners();
        }
        return device;
      },
      onFailure: (error) {
        _errorMessage = error;
        return null;
      },
    );
  }
  
  Future<bool> togglePower(String deviceId, bool powerOn) async {
    final result = await controlDeviceUseCase.execute(
      deviceId: deviceId,
      action: ControlAction.power,
      value: powerOn,
    );
    
    return result.fold(
      onSuccess: (success) {
        if (success) {
          _updateDeviceLocally(deviceId, (device) {
            return device.copyWith(isPowerOn: powerOn);
          });
        }
        return success;
      },
      onFailure: (error) {
        _errorMessage = error;
        return false;
      },
    );
  }
  
  Future<bool> setSpeed(String deviceId, int speed) async {
    final result = await controlDeviceUseCase.execute(
      deviceId: deviceId,
      action: ControlAction.speed,
      value: speed,
    );
    
    return result.fold(
      onSuccess: (success) {
        if (success) {
          _updateDeviceLocally(deviceId, (device) {
            return device.copyWith(speed: speed);
          });
        }
        return success;
      },
      onFailure: (error) {
        _errorMessage = error;
        return false;
      },
    );
  }
  
  Future<bool> toggleLight(String deviceId, bool lightOn) async {
    final result = await controlDeviceUseCase.execute(
      deviceId: deviceId,
      action: ControlAction.light,
      value: lightOn,
    );
    
    return result.fold(
      onSuccess: (success) {
        if (success) {
          _updateDeviceLocally(deviceId, (device) {
            return device.copyWith(isLightOn: lightOn);
          });
        }
        return success;
      },
      onFailure: (error) {
        _errorMessage = error;
        return false;
      },
    );
  }
  
  Future<bool> toggleBreeze(String deviceId, bool breezeOn) async {
    final result = await controlDeviceUseCase.execute(
      deviceId: deviceId,
      action: ControlAction.breeze,
      value: breezeOn,
    );
    
    return result.fold(
      onSuccess: (success) {
        if (success) {
          _updateDeviceLocally(deviceId, (device) {
            return device.copyWith(isBreezeMode: breezeOn);
          });
        }
        return success;
      },
      onFailure: (error) {
        _errorMessage = error;
        return false;
      },
    );
  }
  
  void _updateDeviceLocally(String deviceId, DeviceEntity Function(DeviceEntity) updater) {
    final index = _devices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _devices[index] = updater(_devices[index]);
      notifyListeners();
    }
  }
  
  void startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(AppConstants.refreshInterval, (_) {
      fetchDevices(showLoading: false);
    });
  }
  
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
  
  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}