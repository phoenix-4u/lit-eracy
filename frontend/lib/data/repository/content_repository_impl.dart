import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/config/api_config.dart';
import 'package:lit_eracy/domain/models/content.dart';
import 'package:lit_eracy/domain/repository/content_repository.dart';
import 'package:lit_eracy/domain/models/lesson.dart';
import 'package:lit_eracy/domain/models/achievement.dart';

class ContentRepositoryImpl implements ContentRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  @override
  Future<Either<Failure, List<Lesson>>> fetchLessons(int grade) async {
    // ✅ Added int parameter
    try {
      // Retrieve stored token
      final token = await _getStoredToken();

      if (token == null) {
        return Left(ServerFailure('No authentication token found'));
      }

      final response = await _dio.get(
        '/api/content/lessons',
        queryParameters: {'grade': grade}, // ✅ Use the grade parameter
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List<Lesson> lessons =
          (response.data as List).map((json) => Lesson.fromJson(json)).toList();

      return Right(lessons);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Authentication failed'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to fetch lessons'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> fetchAchievements(
      int userId) async {
    // ✅ Added int parameter
    try {
      final token = await _getStoredToken();

      if (token == null) {
        return Left(ServerFailure('No authentication token found'));
      }

      final response = await _dio.get(
        '/api/users/$userId/achievements', // ✅ Use the userId parameter
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List<Achievement> achievements = (response.data as List)
          .map((json) => Achievement.fromJson(json))
          .toList();

      return Right(achievements);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Authentication failed'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to fetch achievements'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Keep your existing helper methods
  Future<Either<Failure, List<Content>>> getContent({
    int skip = 0,
    int limit = 100,
    String? contentType,
    String? ageGroup,
  }) async {
    try {
      final token = await _getStoredToken();

      if (token == null) {
        return Left(ServerFailure('No authentication token found'));
      }

      final response = await _dio.get(
        '/api/content',
        queryParameters: {
          'skip': skip,
          'limit': limit,
          if (contentType != null) 'content_type': contentType,
          if (ageGroup != null) 'age_group': ageGroup,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List<Content> content = (response.data as List)
          .map((json) => Content.fromJson(json))
          .toList();

      return Right(content);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Authentication failed'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to fetch content'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  Future<Either<Failure, Content>> getContentById(int contentId) async {
    try {
      final token = await _getStoredToken();

      if (token == null) {
        return Left(ServerFailure('No authentication token found'));
      }

      final response = await _dio.get(
        '/api/content/$contentId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final content = Content.fromJson(response.data);
      return Right(content);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Left(ServerFailure('Authentication failed'));
      }
      if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Content not found'));
      }
      return Left(ServerFailure(e.message ?? 'Failed to fetch content'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // Helper method to retrieve stored token
  Future<String?> _getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
