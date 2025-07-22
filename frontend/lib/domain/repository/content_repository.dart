import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/models/lesson.dart';
import 'package:lit_eracy/domain/models/achievement.dart';

abstract class ContentRepository {
  Future<Either<Failure, List<Lesson>>> fetchLessons(int grade);
  Future<Either<Failure, List<Achievement>>> fetchAchievements(int userId);
}
