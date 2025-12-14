class ApiConstants {
  ApiConstants._();
  
  // Base URL
  static const String baseUrl = 'https://api.atomberg-iot.com/v1';
  
  // Endpoints
  static const String devices = '/devices';
  static String device(String id) => '/device/$id';
  static String devicePower(String id) => '/device/$id/power';
  static String deviceSpeed(String id) => '/device/$id/speed';
  static String deviceLight(String id) => '/device/$id/light';
  static String deviceBreeze(String id) => '/device/$id/breeze';
  
  // Headers
  static const String apiKeyHeader = 'x-api-key';
  static const String refreshTokenHeader = 'x-refresh-token';
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Retry
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}