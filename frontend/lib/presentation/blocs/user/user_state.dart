// # File: frontend/lib/presentation/blocs/user/user_state.dart

part of 'user_state.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  final UserPoints? points;

  const UserLoaded({
    required this.user,
    this.points,
  });

  UserLoaded copyWith({
    User? user,
    UserPoints? points,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [user, points];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
