// # File: frontend/lib/presentation/blocs/achievements/achievements_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/usecases/fetch_achievements_usecase.dart';
import '../../../core/usecases/usecase.dart';

part 'achievements_event.dart';
part 'achievements_state.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final FetchAchievementsUseCase getAchievementsUseCase;

  AchievementsBloc({
    required this.getAchievementsUseCase,
  }) : super(AchievementsInitial()) {
    on<LoadAchievements>(_onLoadAchievements);
    on<UnlockAchievement>(_onUnlockAchievement);
  }

  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());

    final result = await getAchievementsUseCase(NoParams());

    result.fold(
      (failure) => emit(AchievementsError(message: failure.message)),
      (achievements) => emit(AchievementsLoaded(achievements: achievements)),
    );
  }

  Future<void> _onUnlockAchievement(
    UnlockAchievement event,
    Emitter<AchievementsState> emit,
  ) async {
    if (state is AchievementsLoaded) {
      final currentState = state as AchievementsLoaded;
      final updatedAchievements = currentState.achievements.map((achievement) {
        if (achievement.id == event.achievementId) {
          return achievement.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
          );
        }
        return achievement;
      }).toList();

      emit(AchievementsLoaded(achievements: updatedAchievements));
      emit(AchievementUnlocked(
          achievement: updatedAchievements.firstWhere(
        (a) => a.id == event.achievementId,
      )));
    }
  }
}
