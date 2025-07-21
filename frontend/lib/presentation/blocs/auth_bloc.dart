import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await _authRepository.login(event.email, event.password);
        emit(AuthSuccess(token: token));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _userRepository.createUser(event.email, event.password);
        final token = await _authRepository.login(event.email, event.password);
        emit(AuthSuccess(token: token));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
