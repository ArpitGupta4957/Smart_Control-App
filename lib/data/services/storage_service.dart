import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }
  
  Future<String?> getString(String key) async {
    return _prefs?.getString(key);
  }
  
  Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }
  
  Future<bool?> getBool(String key) async {
    return _prefs?.getBool(key);
  }
  
  Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }
  
  Future<int?> getInt(String key) async {
    return _prefs?.getInt(key);
  }
  
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }
  
  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
  
  Future<bool> containsKey(String key) async {
    return _prefs?.containsKey(key) ?? false;
  }
}