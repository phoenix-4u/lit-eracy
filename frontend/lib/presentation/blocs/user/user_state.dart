// File: frontend/lib/presentation/blocs/user/user_state.dart

part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  final int points;
  final int level;
  final int streakDays;
  // Add dashboard fields
  final int numLessons;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final List<LessonInfoEntity> recentLessons;
  final List<LessonInfoEntity> recommendedContent;

  const UserLoaded({
    required this.user,
    required this.points,
    required this.level,
    required this.streakDays,
    this.numLessons = 0,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.recentLessons = const [],
    this.recommendedContent = const [],
  });

  @override
  List<Object> get props => [
        user,
        points,
        level,
        streakDays,
        numLessons,
        totalPoints,
        currentStreak,
        longestStreak,
        recentLessons,
        recommendedContent,
      ];
}

class UserFailure extends UserState {
  final String message;

  const UserFailure(this.message);

  @override
  List<Object> get props => [message];
}
