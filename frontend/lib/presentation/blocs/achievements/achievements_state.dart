// # File: frontend/lib/presentation/blocs/achievements/achievements_state.dart

part of 'achievements_bloc.dart';

abstract class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object> get props => [];
}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  final List<Achievement> achievements;

  const AchievementsLoaded({required this.achievements});

  @override
  List<Object> get props => [achievements];
}

class AchievementUnlocked extends AchievementsState {
  final Achievement achievement;

  const AchievementUnlocked({required this.achievement});

  @override
  List<Object> get props => [achievement];
}

class AchievementsError extends AchievementsState {
  final String message;

  const AchievementsError({required this.message});

  @override
  List<Object> get props => [message];
}
