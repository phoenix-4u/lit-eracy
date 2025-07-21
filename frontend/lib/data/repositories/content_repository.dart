import 'package:dio/dio.dart';
import '../models/lesson_model.dart';

class ContentRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));

  Future<List<LessonModel>> fetchLessons(int grade) async {
    final resp = await _dio.get('/content/lessons', queryParameters: {'user_id': grade});
    return (resp.data as List).map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<List<AchievementModel>> fetchAchievements(int userId) async {
    final resp = await _dio.get('/achievements/achievements', queryParameters: {'user_id': userId});
    return (resp.data as List).map((e) => AchievementModel.fromJson(e)).toList();
  }
}
