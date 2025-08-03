// # File: frontend/lib/data/datasources/remote/auth_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';
import '../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData);
  Future<void> logout(String token);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.defaultHeaders,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw const AuthenticationException('Invalid credentials');
      } else {
        throw ServerException('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AuthenticationException || e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error during login');
    }
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.registerEndpoint),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw ValidationException(
            errorData['message'] ?? 'Registration failed');
      } else {
        throw ServerException('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ValidationException || e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error during registration');
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.logoutEndpoint),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw ServerException('Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error during logout');
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.refreshTokenEndpoint),
        headers: ApiConfig.defaultHeaders,
        body: json.encode({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw const AuthenticationException('Token refresh failed');
      }
    } catch (e) {
      if (e is AuthenticationException) {
        rethrow;
      }
      throw const NetworkException('Network error during token refresh');
    }
  }
}
