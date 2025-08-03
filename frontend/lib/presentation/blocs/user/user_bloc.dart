// # File: frontend/lib/presentation/blocs/user/user_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/user_points.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase _getUserProfileUseCase;

  UserBloc(this._getUserProfileUseCase) : super(UserInitial()) {
    on<LoadUserDashboard>(_onLoadUserDashboard);
    on<UpdateUserPoints>(_onUpdateUserPoints);
  }

  Future<void> _onLoadUserDashboard(
    LoadUserDashboard event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    // Mock user data for now
    final user = User(
      id: 1,
      username: 'student1',
      email: 'student@example.com',
      fullName: 'Alex Johnson',
      age: 8,
      grade: 2,
      role: 'student',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final points = UserPoints(
      userId: 1,
      knowledgeGems: 150,
      wordCoins: 75,
      imaginationSparks: 30,
      totalPoints: 255,
      streakDays: 5,
      lastActivityDate: DateTime.now(),
      level: 3,
      experiencePoints: 255,
    );

    emit(UserLoaded(user: user, points: points));
  }

  void _onUpdateUserPoints(
    UpdateUserPoints event,
    Emitter<UserState> emit,
  ) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(currentState.copyWith(points: event.points));
    }
  }
}
