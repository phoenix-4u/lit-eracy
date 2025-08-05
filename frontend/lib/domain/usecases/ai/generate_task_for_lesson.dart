
import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/error/failures.dart';
import 'package:lit_eracy/domain/repositories/ai_repository.dart';
import '../../../domain/entities/task.dart';

class GenerateTaskForLesson {
  final AIRepository repository;

  GenerateTaskForLesson(this.repository);

  Future<Either<Failure, Task>> call(int lessonId) async {
    return await repository.generateTaskForLesson(lessonId);
  }
}
