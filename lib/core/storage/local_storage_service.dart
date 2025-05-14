import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _preferences;
  
  LocalStorageService(this._preferences);
  
  // String methods
  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }
  
  String? getString(String key) {
    return _preferences.getString(key);
  }
  
  // Boolean methods
  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }
  
  // Integer methods
  Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }
  
  int? getInt(String key) {
    return _preferences.getInt(key);
  }
  
  // Double methods
  Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }
  
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }
  
  // Object methods
  Future<bool> setObject(String key, Object value) async {
    return await _preferences.setString(key, jsonEncode(value));
  }
  
  dynamic getObject(String key) {
    final String? jsonString = _preferences.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }
  
  // Remove and clear methods
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }
  
  Future<bool> clear() async {
    return await _preferences.clear();
  }
  
  // Check if key exists
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }
}
