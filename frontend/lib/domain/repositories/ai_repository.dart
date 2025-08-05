import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/task.dart' as entity;

abstract class AIRepository {
  Future<Either<Failure, entity.Task>> generateTaskForLesson(int lessonId);
}
