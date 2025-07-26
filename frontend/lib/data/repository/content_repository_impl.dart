import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/models/lesson.dart';
import 'package:lit_eracy/domain/models/achievement.dart';
import 'package:lit_eracy/domain/repository/content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api'));

  @override
  Future<Either<Failure, List<Lesson>>> fetchLessons(int grade) async {
    try {
      final response =
          await _dio.get('/content/lessons', queryParameters: {'grade': grade});
      final lessons =
          (response.data as List).map((e) => Lesson.fromJson(e)).toList();
      return Right(lessons);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch lessons'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> fetchAchievements(
      int userId) async {
    try {
      final response =
          await _dio.get('/achievements', queryParameters: {'user_id': userId});
      final achievements =
          (response.data as List).map((e) => Achievement.fromJson(e)).toList();
      return Right(achievements);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch achievements'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
