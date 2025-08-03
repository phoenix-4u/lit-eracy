// # File: frontend/lib/domain/usecases/progress/update_progress_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/progress_repository.dart';

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

class UpdateProgressParams extends Equatable {
  final int userId;
  final int contentId;
  final double completionPercentage;
  final int timeSpent;

  const UpdateProgressParams({
    required this.userId,
    required this.contentId,
    required this.completionPercentage,
    required this.timeSpent,
  });

  @override
  List<Object> get props =>
      [userId, contentId, completionPercentage, timeSpent];
}
