import 'package:dartz/dartz.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/models/achievement.dart';
import 'package:lit_eracy/domain/repository/content_repository.dart';

class FetchAchievementsUseCase {
  final ContentRepository repository;

  FetchAchievementsUseCase(this.repository);

  Future<Either<Failure, List<Achievement>>> execute(int userId) async {
    return await repository.fetchAchievements(userId);
  }
}
