import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('$prefix $message');
    }
  }
  
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '';
      debugPrint('$prefix ERROR: $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }
  
  static void network(String method, String url, {int? statusCode, dynamic data}) {
    if (kDebugMode) {
      debugPrint('[NETWORK] $method $url');
      if (statusCode != null) debugPrint('Status: $statusCode');
      if (data != null) debugPrint('Data: $data');
    }
  }
}