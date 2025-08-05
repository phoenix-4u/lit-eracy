
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/error/exceptions.dart';
import '../../models/task_model.dart';

abstract class AIRemoteDataSource {
  Future<TaskModel> generateTaskForLesson(int lessonId);
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final http.Client client;

  AIRemoteDataSourceImpl({required this.client});

  @override
  Future<TaskModel> generateTaskForLesson(int lessonId) async {
    final response = await client.post(
      Uri.parse('http://localhost:8000/api/lessons/$lessonId/generate-task'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to generate task');
    }
  }
}
