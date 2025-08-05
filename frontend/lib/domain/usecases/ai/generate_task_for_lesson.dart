import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/ai_repository.dart';
import '../../entities/task.dart' as entity;

class GenerateTaskForLesson {
  final AIRepository repository;

  GenerateTaskForLesson(this.repository);

  Future<Either<Failure, entity.Task>> call(int lessonId) {
    return repository.generateTaskForLesson(lessonId);
  }
}
