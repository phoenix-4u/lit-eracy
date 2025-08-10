// File: frontend/lib/presentation/blocs/user/user_event.dart

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserEvent {}

class LoadUserDashboard extends UserEvent {
  final String userId;

  const LoadUserDashboard({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadUserDashboardWithToken extends UserEvent {
  final String token;

  const LoadUserDashboardWithToken({required this.token});

  @override
  List<Object> get props => [token];
}

class UpdateUserProfile extends UserEvent {
  final User user;

  const UpdateUserProfile({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserPoints extends UserEvent {
  final int points;

  const UpdateUserPoints({required this.points});

  @override
  List<Object> get props => [points];
}
