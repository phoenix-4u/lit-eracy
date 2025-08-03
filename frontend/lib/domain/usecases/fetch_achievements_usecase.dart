// File: frontend/lib/domain/usecases/fetch_achievements_usecase.dart

import 'package:dartz/dartz.dart';
import '../entities/achievement.dart';
import '../repositories/content_repository.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';

class FetchAchievementsUseCase implements UseCase<List<Achievement>, NoParams> {
  final ContentRepository repository;

  FetchAchievementsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Achievement>>> call(NoParams params) async {
    return await repository.getAchievements();
  }
}
