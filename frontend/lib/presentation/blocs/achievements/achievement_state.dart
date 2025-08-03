// # File: frontend/lib/presentation/blocs/achievements/achievements_state.dart

part of 'achievements_bloc.dart';

abstract class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object?> get props => [];
}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  final List<dynamic> achievements;

  const AchievementsLoaded(this.achievements);

  @override
  List<Object> get props => [achievements];
}

class AchievementUnlocked extends AchievementsState {
  final dynamic achievement;

  const AchievementUnlocked(this.achievement);

  @override
  List<Object> get props => [achievement];
}

class AchievementsError extends AchievementsState {
  final String message;

  const AchievementsError(this.message);

  @override
  List<Object> get props => [message];
}
