// ## File: frontend/lib/data/repositories/ai_repository_impl.dart

import 'package:dartz/dartz.dart';
// --- THIS IS THE FIX ---
// Use relative paths to import files from your own project.
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
// --- END OF FIX ---
import '../datasources/remote/ai_remote_datasource.dart';

import '../models/task_model.dart';

// ## File: frontend/lib/domain/repositories/ai_repository.dart

import '../../domain/entities/task.dart'
    as entity; // Make sure you import your Task entity

import '../../domain/repositories/ai_repository.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, entity.Task>> generateTaskForLesson(
      int lessonId) async {
    try {
      final TaskModel model =
          await remoteDataSource.generateTaskForLesson(lessonId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
