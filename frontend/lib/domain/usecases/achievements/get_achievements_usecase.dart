// # File: frontend/lib/domain/usecases/achievements/get_achievements_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/achievement.dart';
import '../../repositories/achievements_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';

class GetAchievementsUseCase implements UseCase<List<Achievement>, NoParams> {
  final AchievementsRepository repository;

  GetAchievementsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Achievement>>> call(NoParams params) async {
    return await repository.getAchievements();
  }
}
