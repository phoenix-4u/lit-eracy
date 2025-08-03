// File: frontend/lib/domain/usecases/fetch_lessons_usecase.dart

import 'package:dartz/dartz.dart';
import '../entities/lesson.dart';
import '../repositories/content_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class FetchLessonsUseCase implements UseCase<List<Lesson>, FetchLessonsParams> {
  final ContentRepository repository;

  FetchLessonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(FetchLessonsParams params) async {
    return await repository.getLessons(grade: params.grade);
  }
}

class FetchLessonsParams {
  final int? grade;

  FetchLessonsParams({this.grade});
}
