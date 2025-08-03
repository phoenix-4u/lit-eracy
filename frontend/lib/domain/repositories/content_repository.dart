// # File: frontend/lib/domain/repositories/content_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/lesson.dart';
import '../entities/achievement.dart';
import '../entities/content.dart';
import '../../core/error/failures.dart';

abstract class ContentRepository {
  Future<Either<Failure, List<Lesson>>> getLessons({int? grade});
  Future<Either<Failure, List<Achievement>>> getAchievements();
  Future<Either<Failure, List<Content>>> getContent();
  Future<Either<Failure, Lesson>> getLessonById(int id);
  Future<Either<Failure, Content>> getContentById(int id);
}
