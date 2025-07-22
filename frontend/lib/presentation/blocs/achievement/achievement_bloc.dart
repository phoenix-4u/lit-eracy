import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lit_eracy/domain/models/achievement.dart';
import 'package:lit_eracy/domain/usecases/fetch_achievements_usecase.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final FetchAchievementsUseCase fetchAchievementsUseCase;

  AchievementBloc(this.fetchAchievementsUseCase) : super(AchievementInitial()) {
    on<LoadAchievements>((event, emit) async {
      emit(AchievementLoading());
      try {
        final achievements = await fetchAchievementsUseCase.call(event.userId);
        emit(AchievementLoaded(achievements));
      } catch (e) {
        emit(const AchievementError('Failed to load achievements'));
      }
    });
  }
}