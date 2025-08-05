// ## File: frontend/lib/data/datasources/remote/content_remote_datasource.dart (Final Corrected Version)

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

  /// A robust helper function to safely parse any response expected to contain a list.
  /// It handles nulls, empty bodies, and different JSON structures (root list vs. nested list).
  List<Map<String, dynamic>> _safeParseList(http.Response response,
      {String? key}) {
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return []; // Return empty list if body is empty
      }

      final dynamic decodedJson = json.decode(response.body);

      // Case 1: The entire response is a JSON array.
      if (decodedJson is List) {
        return List<Map<String, dynamic>>.from(decodedJson);
      }

      // Case 2: The list is nested under a specific key, e.g., {"lessons": [...]}.
      if (key != null &&
          decodedJson is Map<String, dynamic> &&
          decodedJson.containsKey(key)) {
        final dynamic dataList = decodedJson[key];
        // Ensure the nested data is a list and handle if it's null.
        if (dataList is List) {
          return List<Map<String, dynamic>>.from(dataList);
        }
      }

      // If the format is unexpected, return an empty list to prevent crashes.
      return [];
    } else {
      throw ServerException('Failed to fetch data: ${response.statusCode}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getLessons({int? grade}) async {
    try {
      final queryParams = grade != null ? '?grade=$grade' : '';
      final response = await client.get(
        Uri.parse('${ApiConfig.lessonsEndpoint}$queryParams'),
        headers: ApiConfig.defaultHeaders,
      );
      // FIX: Use the robust helper function. Assumes the API returns a root list.
      return _safeParseList(response);
    } catch (e) {
      if (e is ServerException) rethrow;
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
      // FIX: Use the robust helper, expecting a nested list like {"achievements": [...]}.
      return _safeParseList(response, key: 'achievements');
    } catch (e) {
      if (e is ServerException) rethrow;
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
      // FIX: Use the robust helper, expecting a nested list like {"content": [...]}.
      return _safeParseList(response, key: 'content');
    } catch (e) {
      if (e is ServerException) rethrow;
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
      if (e is ServerException) rethrow;
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
      if (e is ServerException) rethrow;
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
      if (e is ServerException) rethrow;
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
      if (e is ServerException) rethrow;
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
      // FIX: Use the robust helper, expecting a nested list like {"progress": [...]}.
      return _safeParseList(response, key: 'progress');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const NetworkException(
          'Network error while getting content progress');
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
      if (e is ServerException) rethrow;
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
      // FIX: Use the robust helper, expecting a nested list like {"achievements": [...]}.
      return _safeParseList(response, key: 'achievements');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const NetworkException(
          'Network error while getting user achievements');
    }
  }
}
