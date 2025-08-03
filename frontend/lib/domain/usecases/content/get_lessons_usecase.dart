// # File: frontend/lib/domain/usecases/content/get_lessons_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/content_repository.dart';

class GetLessonsUseCase implements UseCase<List<dynamic>, GetLessonsParams> {
  final ContentRepository repository;

  GetLessonsUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(GetLessonsParams params) async {
    return await repository.getLessons(
      subject: params.subject,
      gradeLevel: params.gradeLevel,
    );
  }
}

class GetLessonsParams extends Equatable {
  final String? subject;
  final int? gradeLevel;

  const GetLessonsParams({this.subject, this.gradeLevel});

  @override
  List<Object?> get props => [subject, gradeLevel];
}
