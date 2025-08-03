// # File: frontend/lib/data/datasources/remote/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
  Future<User> register(String username, String email, String password,
      String fullName, int? age, int? grade);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<User> login(String username, String password) async {
    final response = await dio.post('/api/auth/login', data: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      return User.fromJson(response.data['user']);
    } else {
      throw Exception('Login failed');
    }
  }

  @override
  Future<User> register(String username, String email, String password,
      String fullName, int? age, int? grade) async {
    final response = await dio.post('/api/auth/register', data: {
      'username': username,
      'email': email,
      'password': password,
      'full_name': fullName,
      'age': age,
      'grade': grade,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Registration failed');
    }
  }
}
