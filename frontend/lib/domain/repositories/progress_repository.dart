// # File: frontend/lib/domain/repositories/progress_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/progress.dart';
import '../../core/error/failures.dart';

abstract class ProgressRepository {
  Future<Either<Failure, void>> updateProgress(String userId, String contentId,
      double completionPercentage, int timeSpent);
  Future<Either<Failure, Progress>> getUserProgress(String userId);
  Future<Either<Failure, List<Progress>>> getProgressByContent(
      String contentId);
}
