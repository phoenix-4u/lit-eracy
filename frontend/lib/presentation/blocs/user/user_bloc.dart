// # File: frontend/lib/presentation/blocs/user/user_bloc.dart (Fixed)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/user/get_user_profile_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  UserBloc({required this.getUserProfileUseCase}) : super(const UserInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LoadUserDashboard>(_onLoadUserDashboard);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserPoints>(_onUpdateUserPoints);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await getUserProfileUseCase(
      GetUserProfileParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onLoadUserDashboard(
    LoadUserDashboard event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    final result = await getUserProfileUseCase(
      GetUserProfileParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserLoaded(
        user: user,
        points: 150, // Mock data - in real app, fetch from gamification service
        level: 3,
        streakDays: 7,
      )),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    // Implementation for updating user profile
    // This would require an UpdateUserProfileUseCase
    emit(const UserError(message: 'Update user profile not implemented'));
  }

  Future<void> _onUpdateUserPoints(
    UpdateUserPoints event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;
    if (currentState is UserLoaded) {
      emit(currentState.copyWith(points: event.points));
    }
  }
}
