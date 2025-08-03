// # File: frontend/lib/presentation/blocs/achievements/achievements_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/achievements/get_achievements_usecase.dart';

part 'achievements_event.dart';
part 'achievements_state.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final GetAchievementsUseCase _getAchievementsUseCase;

  AchievementsBloc(this._getAchievementsUseCase)
      : super(AchievementsInitial()) {
    on<LoadAchievements>(_onLoadAchievements);
    on<UnlockAchievement>(_onUnlockAchievement);
  }

  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(AchievementsLoading());

    // Mock achievements data
    final achievements = [
      {
        'id': 1,
        'name': 'First Steps',
        'description': 'Completed your first lesson!',
        'badge_icon': '🏆',
        'earned_at': '2024-01-10T09:00:00Z'
      },
      {
        'id': 2,
        'name': 'Week Streak',
        'description': 'Learned for 7 days in a row!',
        'badge_icon': '🔥',
        'earned_at': '2024-01-15T10:00:00Z'
      }
    ];

    emit(AchievementsLoaded(achievements));
  }

  void _onUnlockAchievement(
    UnlockAchievement event,
    Emitter<AchievementsState> emit,
  ) {
    emit(AchievementUnlocked(event.achievement));

    if (state is AchievementsLoaded) {
      final currentState = state as AchievementsLoaded;
      final updatedAchievements = List.from(currentState.achievements)
        ..add(event.achievement);
      emit(AchievementsLoaded(updatedAchievements));
    }
  }
}
