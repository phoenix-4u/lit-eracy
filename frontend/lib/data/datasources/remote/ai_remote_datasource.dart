// ## File: frontend/lib/data/datasources/remote/ai_remote_datasource.dart (Final Corrected Version)

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../../core/error/exceptions.dart';
import '../../models/task_model.dart';

abstract class AIRemoteDataSource {
  /// Calls the backend AI endpoint to generate a new task for [lessonId].
  /// Throws a [ServerException] for all error codes.
  Future<TaskModel> generateTaskForLesson(int lessonId);
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final http.Client client;

  AIRemoteDataSourceImpl(this.client);

  @override
  Future<TaskModel> generateTaskForLesson(int lessonId) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.apiVersion}/ai/tasks/$lessonId');

    try {
      final response = await client.get(url, headers: ApiConfig.defaultHeaders);

      if (response.statusCode == 200) {
        // --- THIS IS THE DEFINITIVE FIX ---

        // 1. Handle empty body to prevent json.decode from crashing.
        if (response.body.isEmpty) {
          throw const ServerException(
              'API returned a successful status but with an empty body.');
        }

        // 2. Safely decode the JSON.
        final dynamic decodedJson = json.decode(response.body);

        // 3. Check if the decoded JSON is the expected Map format.
        if (decodedJson is Map<String, dynamic>) {
          // 4. If everything is correct, parse it and return.
          return TaskModel.fromJson(decodedJson);
        } else {
          // If the format is wrong (e.g., a list or a primitive), throw an exception.
          throw const ServerException('API returned an unexpected JSON format.');
        }
      } else {
        // Handle non-200 status codes (like 404, 500, etc.)
        throw ServerException(
            'AI generation failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Re-throw known exceptions and wrap unknown ones in a NetworkException.
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException(
          'An unexpected network error occurred: ${e.toString()}');
    }
  }
}
