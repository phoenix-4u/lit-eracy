// File: frontend/lib/presentation/blocs/user/user_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LoadUserDashboard>(_onLoadUserDashboard);
    on<LoadUserDashboardWithToken>(_onLoadUserDashboardWithToken);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserPoints>(_onUpdateUserPoints);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getCurrentUser();
      emit(UserLoaded(
        user: user,
        points: 0, // Default values
        level: 1,
        streakDays: 0,
      ));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onLoadUserDashboard(
    LoadUserDashboard event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      // Get token from storage or use existing method
      final user = await userRepository.getCurrentUser();
      emit(UserLoaded(
        user: user,
        points: 0, // You can keep existing logic here
        level: 1,
        streakDays: 0,
      ));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> _onLoadUserDashboardWithToken(
    LoadUserDashboardWithToken event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final dashboard = await userRepository.fetchStudentDashboard(event.token);

      // Get current user or use a default
      User currentUser = User.empty();
      if (state is UserLoaded) {
        currentUser = (state as UserLoaded).user;
      } else {
        try {
          currentUser = await userRepository.getCurrentUser();
        } catch (_) {
          // Use empty user if can't fetch
        }
      }

      emit(UserLoaded(
        user: currentUser,
        points: dashboard.points.totalPoints,
        level: 1, // Keep existing or calculate from points
        streakDays: dashboard.points.currentStreak,
        numLessons: dashboard.numLessons,
        totalPoints: dashboard.points.totalPoints,
        currentStreak: dashboard.points.currentStreak,
        longestStreak: dashboard.points.longestStreak,
        recentLessons: dashboard.recentLessons,
        recommendedContent: dashboard.recommendedContent,
      ));
    } catch (e) {
      emit(UserFailure('Could not load dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserState> emit,
  ) async {
    // Your existing implementation
  }

  Future<void> _onUpdateUserPoints(
    UpdateUserPoints event,
    Emitter<UserState> emit,
  ) async {
    // Your existing implementation
  }
}
