// # File: frontend/lib/data/datasources/remote/content_remote_datasource.dart

import 'package:dio/dio.dart';

abstract class ContentRemoteDataSource {
  Future<List<dynamic>> getLessons({String? subject, int? gradeLevel});
  Future<List<dynamic>> getContent({String? subject, int? gradeLevel});
  Future<void> updateProgress(
      int userId, int contentId, double completionPercentage, int timeSpent);
  Future<List<dynamic>> getUserProgress(int userId);
  Future<List<dynamic>> getAchievements(int userId);
  Future<void> unlockAchievement(int userId, int achievementId);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final Dio dio;

  ContentRemoteDataSourceImpl(this.dio);

  @override
  Future<List<dynamic>> getLessons({String? subject, int? gradeLevel}) async {
    final queryParams = <String, dynamic>{};
    if (subject != null) queryParams['subject'] = subject;
    if (gradeLevel != null) queryParams['grade_level'] = gradeLevel;

    final response =
        await dio.get('/api/content/lessons', queryParameters: queryParams);

    if (response.statusCode == 200) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to get lessons');
    }
  }

  @override
  Future<List<dynamic>> getContent({String? subject, int? gradeLevel}) async {
    final queryParams = <String, dynamic>{};
    if (subject != null) queryParams['subject'] = subject;
    if (gradeLevel != null) queryParams['grade_level'] = gradeLevel;

    final response =
        await dio.get('/api/content', queryParameters: queryParams);

    if (response.statusCode == 200) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to get content');
    }
  }

  @override
  Future<void> updateProgress(int userId, int contentId,
      double completionPercentage, int timeSpent) async {
    final response = await dio.post('/api/progress/update', data: {
      'user_id': userId,
      'content_id': contentId,
      'completion_percentage': completionPercentage,
      'time_spent': timeSpent,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to update progress');
    }
  }

  @override
  Future<List<dynamic>> getUserProgress(int userId) async {
    final response = await dio.get('/api/progress/$userId');

    if (response.statusCode == 200) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to get user progress');
    }
  }

  @override
  Future<List<dynamic>> getAchievements(int userId) async {
    final response = await dio.get('/api/achievements/$userId');

    if (response.statusCode == 200) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Failed to get achievements');
    }
  }

  @override
  Future<void> unlockAchievement(int userId, int achievementId) async {
    final response = await dio.post('/api/achievements/unlock', data: {
      'user_id': userId,
      'achievement_id': achievementId,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to unlock achievement');
    }
  }
}
