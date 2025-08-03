// # File: frontend/lib/core/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class StorageService {
  Future<void> store(String key, dynamic value);
  Future<T?> get<T>(String key);
  Future<String?> getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences _prefs;

  StorageServiceImpl(this._prefs);

  @override
  Future<void> store(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      // Store as JSON string for complex objects
      await _prefs.setString(key, json.encode(value));
    }
  }

  @override
  Future<T?> get<T>(String key) async {
    final value = _prefs.get(key);
    if (value == null) return null;

    if (T == String) return value as T?;
    if (T == int) return value as T?;
    if (T == double) return value as T?;
    if (T == bool) return value as T?;
    if (T == List<String>) return value as T?;

    // Try to decode JSON for complex objects
    try {
      if (value is String) {
        return json.decode(value) as T?;
      }
    } catch (e) {
      return null;
    }

    return value as T?;
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
