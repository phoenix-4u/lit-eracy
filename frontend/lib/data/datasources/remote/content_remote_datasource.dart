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
      throw NetworkException('Network error while fetching lessons');
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
      throw NetworkException('Network error while fetching achievements');
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
      throw NetworkException('Network error while fetching content');
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
        throw ServerException('Lesson not found');
      } else {
        throw ServerException('Failed to fetch lesson: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error while fetching lesson');
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
        throw ServerException('Content not found');
      } else {
        throw ServerException(
            'Failed to fetch content: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error while fetching content');
    }
  }
}
