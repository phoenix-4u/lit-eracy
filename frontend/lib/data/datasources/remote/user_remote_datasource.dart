// File: frontend/lib/data/datasources/remote/user_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/user_points.dart';
import '../../models/dashboard_model.dart';

abstract class UserRemoteDataSource {
  Future<UserPoints> getUserPoints(String userId);
  Future<User> getUserProfile(String userId);
  Future<Dashboard> getStudentDashboard(String token);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<UserPoints> getUserPoints(String userId) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/tasks/points'),
      headers: ApiConfig.defaultHeaders,
    );

    if (response.statusCode == 200) {
      return UserPoints.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to get user points');
    }
  }

  @override
  Future<User> getUserProfile(String userId) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/me'),
      headers: ApiConfig.defaultHeaders,
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw const ServerException('Failed to get user profile');
    }
  }

  @override
  Future<Dashboard> getStudentDashboard(String token) async {
    final response = await client.get(
      Uri.parse(ApiConfig.studentDashboardEndpoint),
      headers: ApiConfig.authHeaders(token),
    );

    if (response.statusCode == 200) {
      return Dashboard.fromRawJson(response.body);
    } else {
      throw const ServerException('Failed to load dashboard');
    }
  }
}
