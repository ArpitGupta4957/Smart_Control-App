import 'package:flutter/material.dart';
import '../../core/constants/storage_keys.dart';
import '../../data/services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final StorageService storageService;
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeProvider(this.storageService) {
    _loadThemeMode();
  }
  
  Future<void> _loadThemeMode() async {
    final isDark = await storageService.getBool(StorageKeys.isDarkMode);
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
  
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    await storageService.setBool(
      StorageKeys.isDarkMode, 
      _themeMode == ThemeMode.dark,
    );
    
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await storageService.setBool(
      StorageKeys.isDarkMode, 
      mode == ThemeMode.dark,
    );
    notifyListeners();
  }
}