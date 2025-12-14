import 'package:dio/dio.dart';
import '../../data/services/storage_service.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';

class ApiInterceptor extends Interceptor {
  final StorageService storageService;
  
  ApiInterceptor(this.storageService);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add authentication headers
    final apiKey = await storageService.getString(StorageKeys.apiKey);
    final refreshToken = await storageService.getString(StorageKeys.refreshToken);
    
    if (apiKey != null) {
      options.headers[ApiConstants.apiKeyHeader] = apiKey;
    }
    if (refreshToken != null) {
      options.headers[ApiConstants.refreshTokenHeader] = refreshToken;
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 429 Rate Limit with exponential backoff
    if (err.response?.statusCode == 429) {
      // In production, implement retry logic here
    }
    
    handler.next(err);
  }
}