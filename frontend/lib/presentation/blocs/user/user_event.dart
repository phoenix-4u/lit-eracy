// # File: frontend/lib/presentation/blocs/user/user_event.dart

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserDashboard extends UserEvent {
  final int userId;

  const LoadUserDashboard(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateUserPoints extends UserEvent {
  final UserPoints points;

  const UpdateUserPoints(this.points);

  @override
  List<Object> get props => [points];
}
