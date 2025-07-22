import 'package:bloc/bloc.dart';
import 'package:lit_eracy/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase.execute(event.username, event.password);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });
  }
}
