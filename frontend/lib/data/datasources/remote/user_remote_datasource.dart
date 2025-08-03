// # File: frontend/lib/data/datasources/remote/user_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../../core/error/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> getUserProfile(String userId);
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData);
  Future<void> deleteUser(String userId);
  Future<List<Map<String, dynamic>>> getUsers({int? page, int? limit});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}/$userId'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['user'] as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw const ServerException('User not found');
      } else {
        throw ServerException(
            'Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while getting user profile');
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> userData) async {
    try {
      final response = await client.put(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}/${userData['id']}'),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['user'] as Map<String, dynamic>;
      } else {
        throw ServerException(
            'Failed to update user profile: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while updating user profile');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}/$userId'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while deleting user');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUsers({int? page, int? limit}) async {
    try {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}')
          .replace(queryParameters: queryParams);

      final response = await client.get(uri, headers: ApiConfig.defaultHeaders);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['users'] ?? []);
      } else {
        throw ServerException('Failed to get users: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while getting users');
    }
  }
}
