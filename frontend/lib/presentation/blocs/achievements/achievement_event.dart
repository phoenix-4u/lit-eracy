// # File: frontend/lib/presentation/blocs/achievements/achievements_event.dart

part of 'achievements_bloc.dart';

abstract class AchievementsEvent extends Equatable {
  const AchievementsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAchievements extends AchievementsEvent {
  final int userId;

  const LoadAchievements(this.userId);

  @override
  List<Object> get props => [userId];
}

class UnlockAchievement extends AchievementsEvent {
  final dynamic achievement;

  const UnlockAchievement(this.achievement);

  @override
  List<Object> get props => [achievement];
}
