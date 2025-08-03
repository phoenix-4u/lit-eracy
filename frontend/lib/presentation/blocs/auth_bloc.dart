// lib/presentation/blocs/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ai_literacy_app/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent); // Register event handler
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    final failureOrUser = await loginUseCase(LoginParams(username: event.username, password: event.password));
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
}
