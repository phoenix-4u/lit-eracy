part of 'achievement_bloc.dart';

abstract class AchievementEvent {}

class LoadAchievements extends AchievementEvent {
  final int userId;
  LoadAchievements(this.userId);
}
