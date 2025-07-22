// lib/presentation/blocs/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lit_eracy/core/errors/failures.dart';
import 'package:lit_eracy/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent); // Register event handler
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    final result = await loginUseCase.execute(event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailure(error: failure.message)),
      (token) => emit(AuthSuccess(token: token)),
    );
  }
}
