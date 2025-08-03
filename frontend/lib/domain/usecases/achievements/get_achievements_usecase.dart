// # File: frontend/lib/domain/usecases/achievements/get_achievements_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/achievements_repository.dart';

class GetAchievementsUseCase
    implements UseCase<List<dynamic>, GetAchievementsParams> {
  final AchievementsRepository repository;

  GetAchievementsUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(
      GetAchievementsParams params) async {
    return await repository.getAchievements(params.userId);
  }
}

class GetAchievementsParams extends Equatable {
  final int userId;

  const GetAchievementsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
