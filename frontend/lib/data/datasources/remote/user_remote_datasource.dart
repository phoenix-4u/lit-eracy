// # File: frontend/lib/data/datasources/remote/user_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/user_points.dart';

abstract class UserRemoteDataSource {
  Future<User> getUserProfile(int userId);
  Future<UserPoints> getUserPoints(int userId);
  Future<void> updateUserPoints(int userId, UserPoints points);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<User> getUserProfile(int userId) async {
    final response = await dio.get('/api/users/$userId');

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  @override
  Future<UserPoints> getUserPoints(int userId) async {
    final response = await dio.get('/api/users/$userId/points');

    if (response.statusCode == 200) {
      return UserPoints.fromJson(response.data);
    } else {
      throw Exception('Failed to get user points');
    }
  }

  @override
  Future<void> updateUserPoints(int userId, UserPoints points) async {
    final response =
        await dio.put('/api/users/$userId/points', data: points.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to update user points');
    }
  }
}
