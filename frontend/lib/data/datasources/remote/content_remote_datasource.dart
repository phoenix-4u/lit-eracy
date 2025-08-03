// # File: frontend/lib/data/datasources/remote/content_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../../core/error/exceptions.dart';

abstract class ContentRemoteDataSource {
  Future<List<Map<String, dynamic>>> getLessons({int? grade});
  Future<List<Map<String, dynamic>>> getAchievements();
  Future<List<Map<String, dynamic>>> getContent();
  Future<Map<String, dynamic>> getLessonById(int id);
  Future<Map<String, dynamic>> getContentById(int id);
  Future<void> updateProgress(String userId, String contentId,
      double completionPercentage, int timeSpent);
  Future<Map<String, dynamic>> getUserProgress(String userId);
  Future<List<Map<String, dynamic>>> getProgressByContent(String contentId);
  Future<void> unlockAchievement(String userId, String achievementId);
  Future<List<Map<String, dynamic>>> getUserAchievements(String userId);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final http.Client client;

  ContentRemoteDataSourceImpl(this.client);

  @override
  Future<List<Map<String, dynamic>>> getLessons({int? grade}) async {
    try {
      final queryParams = grade != null ? '?grade=$grade' : '';
      final response = await client.get(
        Uri.parse('${ApiConfig.lessonsEndpoint}$queryParams'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['lessons'] ?? []);
      } else {
        throw ServerException(
            'Failed to fetch lessons: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while fetching lessons');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAchievements() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConfig.achievementsEndpoint),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['achievements'] ?? []);
      } else {
        throw ServerException(
            'Failed to fetch achievements: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while fetching achievements');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getContent() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiVersion}/content'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['content'] ?? []);
      } else {
        throw ServerException(
            'Failed to fetch content: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while fetching content');
    }
  }

  @override
  Future<Map<String, dynamic>> getLessonById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.lessonsEndpoint}/$id'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['lesson'] as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw const ServerException('Lesson not found');
      } else {
        throw ServerException('Failed to fetch lesson: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while fetching lesson');
    }
  }

  @override
  Future<Map<String, dynamic>> getContentById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiVersion}/content/$id'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['content'] as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw const ServerException('Content not found');
      } else {
        throw ServerException(
            'Failed to fetch content: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while fetching content');
    }
  }

  @override
  Future<void> updateProgress(String userId, String contentId,
      double completionPercentage, int timeSpent) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiVersion}/progress'),
        headers: ApiConfig.defaultHeaders,
        body: json.encode({
          'user_id': userId,
          'content_id': contentId,
          'completion_percentage': completionPercentage,
          'time_spent': timeSpent,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
            'Failed to update progress: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while updating progress');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserProgress(String userId) async {
    try {
      final response = await client.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.apiVersion}/progress/user/$userId'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['progress'] as Map<String, dynamic>;
      } else {
        throw ServerException(
            'Failed to get user progress: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while getting user progress');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getProgressByContent(
      String contentId) async {
    try {
      final response = await client.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.apiVersion}/progress/content/$contentId'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['progress'] ?? []);
      } else {
        throw ServerException(
            'Failed to get content progress: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while getting content progress');
    }
  }

  @override
  Future<void> unlockAchievement(String userId, String achievementId) async {
    try {
      final response = await client.post(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.apiVersion}/achievements/unlock'),
        headers: ApiConfig.defaultHeaders,
        body: json.encode({
          'user_id': userId,
          'achievement_id': achievementId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
            'Failed to unlock achievement: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while unlocking achievement');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    try {
      final response = await client.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.apiVersion}/achievements/user/$userId'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonData['achievements'] ?? []);
      } else {
        throw ServerException(
            'Failed to get user achievements: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw const NetworkException('Network error while getting user achievements');
    }
  }
}
