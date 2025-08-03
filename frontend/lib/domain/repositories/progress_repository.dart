// # File: frontend/lib/domain/repositories/progress_repository.dart

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class ProgressRepository {
  Future<Either<Failure, void>> updateProgress(
      int userId, int contentId, double completionPercentage, int timeSpent);
  Future<Either<Failure, List<dynamic>>> getUserProgress(int userId);
}
