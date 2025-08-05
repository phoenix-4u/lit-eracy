// File: frontend/lib/data/datasources/remote/ai_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../../core/error/exceptions.dart';
import '../../models/task_model.dart';

abstract class AIRemoteDataSource {
  /// Calls the backend AI endpoint to generate a new task for [lessonId].
  /// Returns a TaskModel on success or throws a [ServerException].
  Future<TaskModel> generateTaskForLesson(int lessonId);
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final http.Client client;

  AIRemoteDataSourceImpl(this.client);

  @override
  Future<TaskModel> generateTaskForLesson(int lessonId) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.apiVersion}/ai/tasks/$lessonId');
    final response = await client.get(
      url,
      headers: ApiConfig.defaultHeaders,
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return TaskModel.fromJson(jsonMap);
    } else {
      throw ServerException('AI generation failed: ${response.statusCode}');
    }
  }
}
