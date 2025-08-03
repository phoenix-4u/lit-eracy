// # File: frontend/lib/presentation/blocs/auth/auth_event.dart

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> userData;

  const RegisterRequested({required this.userData});

  @override
  List<Object> get props => [userData];
}

class LogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
