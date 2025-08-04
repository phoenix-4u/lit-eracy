// # File: frontend/lib/presentation/blocs/achievements/achievements_event.dart

part of 'achievements_bloc.dart';

abstract class AchievementsEvent extends Equatable {
  const AchievementsEvent();

  @override
  List<Object> get props => [];
}

class LoadAchievements extends AchievementsEvent {}

class UnlockAchievement extends AchievementsEvent {
  final String achievementId;

  const UnlockAchievement({required this.achievementId});

  @override
  List<Object> get props => [achievementId];
}
