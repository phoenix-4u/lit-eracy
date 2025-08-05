
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/task.dart';

abstract class AIRepository {
  Future<Either<Failure, Task>> generateTaskForLesson(int lessonId);
}
