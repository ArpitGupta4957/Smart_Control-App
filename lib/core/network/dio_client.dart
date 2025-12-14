import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../../data/services/storage_service.dart';
import 'api_interceptor.dart';
import '../utils/logger.dart';

class DioClient {
  late final Dio dio;
  
  DioClient(StorageService storageService) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
      ),
    );
    
    // Add interceptors
    dio.interceptors.add(ApiInterceptor(storageService));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => Logger.log(obj.toString(), tag: 'DIO'),
    ));
  }
}