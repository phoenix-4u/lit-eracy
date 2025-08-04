// # File: frontend/lib/presentation/blocs/user/user_state.dart (Fixed)

part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User user;
  final int points;
  final int level;
  final int streakDays;

  const UserLoaded({
    required this.user,
    this.points = 0,
    this.level = 1,
    this.streakDays = 0,
  });

  @override
  List<Object> get props => [user, points, level, streakDays];

  UserLoaded copyWith({
    User? user,
    int? points,
    int? level,
    int? streakDays,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      points: points ?? this.points,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}
