// # File: frontend/lib/domain/usecases/progress/update_progress_usecase.dart

import 'package:dartz/dartz.dart';
import '../../repositories/progress_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';

class UpdateProgressUseCase implements UseCase<void, UpdateProgressParams> {
  final ProgressRepository repository;

  UpdateProgressUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProgressParams params) async {
    return await repository.updateProgress(
      params.userId,
      params.contentId,
      params.completionPercentage,
      params.timeSpent,
    );
  }
}

class UpdateProgressParams {
  final String userId;
  final String contentId;
  final double completionPercentage;
  final int timeSpent;

  UpdateProgressParams({
    required this.userId,
    required this.contentId,
    required this.completionPercentage,
    required this.timeSpent,
  });
}
