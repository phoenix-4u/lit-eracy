import 'package:bloc/bloc.dart';
import 'package:lit_eracy/domain/usecases/fetch_achievements_usecase.dart';
import 'package:lit_eracy/domain/models/achievement.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final FetchAchievementsUseCase useCase;

  AchievementBloc(this.useCase) : super(AchievementInitial()) {
    on<LoadAchievements>((event, emit) async {
      emit(AchievementLoading());
      final result = await useCase.execute(event.userId);
      result.fold(
        (failure) => emit(AchievementError(failure.message)),
        (achievements) => emit(AchievementLoaded(achievements)),
      );
    });
  }
}
