// # File: frontend/lib/domain/usecases/content/get_lessons_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/lesson.dart';
import '../../repositories/content_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';

class GetLessonsUseCase implements UseCase<List<Lesson>, GetLessonsParams> {
  final ContentRepository repository;

  GetLessonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(GetLessonsParams params) async {
    return await repository.getLessons(grade: params.grade);
  }
}

class GetLessonsParams {
  final int? grade;

  GetLessonsParams({this.grade});
}
