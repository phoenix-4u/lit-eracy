// # File: frontend/lib/presentation/blocs/achievements/achievements_bloc.dart (Fixed)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/achievement.dart';
import '../../../domain/usecases/achievements/get_achievements_usecase.dart';
import '../../../core/usecases/usecase.dart';

part 'achievements_event.dart';
part 'achievements_state.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final GetAchievementsUseCase getAchievementsUseCase;

  AchievementsBloc({required this.getAchievementsUseCase})
      : super(const AchievementsInitial()) {
    on<LoadAchievements>(_onLoadAchievements);
    on<UnlockAchievement>(_onUnlockAchievement);
  }

  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(const AchievementsLoading());

    final result = await getAchievementsUseCase(const NoParams());

    result.fold(
      (failure) => emit(AchievementsError(message: failure.message)),
      (achievements) => emit(AchievementsLoaded(achievements: achievements)),
    );
  }

  Future<void> _onUnlockAchievement(
    UnlockAchievement event,
    Emitter<AchievementsState> emit,
  ) async {
    // Implementation for unlocking achievement
    // This would require an UnlockAchievementUseCase
    emit(
        const AchievementsError(message: 'Unlock achievement not implemented'));
  }
}
