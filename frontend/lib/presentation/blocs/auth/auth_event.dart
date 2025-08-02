// # File: frontend/lib/presentation/blocs/auth/auth_event.dart

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitialEvent extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String fullName;
  final int? age;
  final int? grade;

  const RegisterRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    this.age,
    this.grade,
  });

  @override
  List<Object?> get props => [username, email, password, fullName, age, grade];
}

class LogoutRequested extends AuthEvent {}
