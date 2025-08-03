// # File: frontend/lib/domain/repositories/content_repository.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class ContentRepository {
  Future<Either<Failure, List<dynamic>>> getLessons(
      {String? subject, int? gradeLevel});
  Future<Either<Failure, List<dynamic>>> getContent(
      {String? subject, int? gradeLevel});
}
