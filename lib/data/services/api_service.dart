import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/device_model.dart';
import '../models/control_response_model.dart';
import '../models/error_model.dart';

class ApiService {
  final Dio dio;
  
  ApiService(this.dio);
  
  // Fetch all devices
  Future<List<DeviceModel>> fetchDevices() async {
    try {
      Logger.network('GET', ApiConstants.devices);
      final response = await dio.get(ApiConstants.devices);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['devices'] ?? response.data;
        return data.map((json) => DeviceModel.fromJson(json)).toList();
      }
      
      throw _handleError(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  // Fetch single device
  Future<DeviceModel> fetchDevice(String deviceId) async {
    try {
      Logger.network('GET', ApiConstants.device(deviceId));
      final response = await dio.get(ApiConstants.device(deviceId));
      
      if (response.statusCode == 200) {
        return DeviceModel.fromJson(response.data);
      }
      
      throw _handleError(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  // Control device power
  Future<ControlResponseModel> controlPower(String deviceId, bool powerOn) async {
    try {
      Logger.network('POST', ApiConstants.devicePower(deviceId));
      final response = await dio.post(
        ApiConstants.devicePower(deviceId),
        data: {'power': powerOn},
      );
      
      if (response.statusCode == 200) {
        return ControlResponseModel.fromJson(response.data);
      }
      
      throw _handleError(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  // Control device speed
  Future<ControlResponseModel> controlSpeed(String deviceId, int speed) async {
    try {
      Logger.network('POST', ApiConstants.deviceSpeed(deviceId));
      final response = await dio.post(
        ApiConstants.deviceSpeed(deviceId),
        data: {'speed': speed},
      );
      
      if (response.statusCode == 200) {
        return ControlResponseModel.fromJson(response.data);
      }
      
      throw _handleError(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  // Control device light
  Future<ControlResponseModel> controlLight(String deviceId, bool lightOn) async {
    try {
      Logger.network('POST', ApiConstants.deviceLight(deviceId));
      final response = await dio.post(
        ApiConstants.deviceLight(deviceId),
        data: {'light': lightOn},
      );
      
      if (response.statusCode == 200) {
        return ControlResponseModel.fromJson(response.data);
      }
      
      throw _handleError(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  // Control device breeze mode
  Future<ControlResponseModel> controlBreeze(String deviceId, bool breezeOn) async {
    try {
      Logger.network('POST', ApiConstants.deviceBreeze(deviceId));
      final response = await dio.post(
        ApiConstants.deviceBreeze(deviceId),
        data: {'breeze': breezeOn},
      );
      
      if (response.statusCode == 200) {
        return ControlResponseModel.fromJson(response.data);
      }
      
      throw _handleError(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  // Error handling
  AppException _handleError(Response response) {
    final errorModel = ErrorModel.fromJson(
      response.data is Map ? response.data : {},
      response.statusCode ?? 500,
    );
    
    switch (response.statusCode) {
      case 401:
        return AuthException(errorModel.message);
      case 403:
        return AuthException('Developer mode is disabled');
      case 404:
        return NotFoundException(errorModel.message);
      case 429:
        return RateLimitException(errorModel.message);
      case 500:
      case 502:
      case 503:
        return ServerException(errorModel.message);
      default:
        return UnexpectedException(errorModel.message);
    }
  }
  
  AppException _handleDioException(DioException e) {
    Logger.error('DioException', error: e);
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('Connection timeout');
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return NetworkException('No internet connection');
    }
    
    if (e.response != null) {
      return _handleError(e.response!);
    }
    
    return UnexpectedException(e.message ?? 'Unknown error');
  }
}