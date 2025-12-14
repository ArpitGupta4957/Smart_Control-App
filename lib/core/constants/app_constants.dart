class AppConstants {
  AppConstants._();
  
  // App Info
  static const String appName = 'Atomberg Fan Controller';
  static const String appVersion = '1.0.0';
  
  // Polling
  static const Duration refreshInterval = Duration(seconds: 5);
  
  // Animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fanRotationDuration = Duration(milliseconds: 800);
  
  // UI
  static const double borderRadius = 16.0;
  static const double elevation = 2.0;
  static const double iconSize = 24.0;
  
  // Speed Limits
  static const int minSpeed = 1;
  static const int maxSpeed = 5;
}