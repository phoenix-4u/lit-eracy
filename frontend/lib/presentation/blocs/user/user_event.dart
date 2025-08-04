// # File: frontend/lib/presentation/blocs/user/user_event.dart (Extended)

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserEvent {
  final String userId;

  const LoadUserProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadUserDashboard extends UserEvent {
  final String userId;

  const LoadUserDashboard({required this.userId});

  @override
  List<Object> get props => [userId];
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
