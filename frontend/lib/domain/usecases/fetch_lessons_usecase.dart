import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/models/lesson.dart';
import 'package:lit_eracy/domain/repository/content_repository.dart';

class FetchLessonsUseCase {
  final ContentRepository repository;

  FetchLessonsUseCase(this.repository);

  Future<Either<Failure, List<Lesson>>> execute(int grade) async {
    return await repository.fetchLessons(grade);
  }
}
