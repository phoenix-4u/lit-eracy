// # File: frontend/lib/data/datasources/local/local_storage_datasource.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../domain/entities/user.dart';

abstract class LocalStorageDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> removeUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final SharedPreferences sharedPreferences;

  LocalStorageDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUser(User user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString('user', userJson);
  }

  @override
  Future<User?> getUser() async {
    final userJson = sharedPreferences.getString('user');
    if (userJson != null) {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    }
    return null;
  }

  @override
  Future<void> removeUser() async {
    await sharedPreferences.remove('user');
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('token', token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString('token');
  }

  @override
  Future<void> removeToken() async {
    await sharedPreferences.remove('token');
  }
}
