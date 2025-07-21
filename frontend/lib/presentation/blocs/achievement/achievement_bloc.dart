import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_achievements_usecase.dart';
import '../../../data/models/achievement_model.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final FetchAchievementsUseCase _useCase;
  AchievementBloc(this._useCase) : super(AchievementInitial()) {
    on<LoadAchievements>((event, emit) async {
      emit(AchievementLoading());
      try {
        final items = await _useCase.execute(event.userId);
        emit(AchievementLoaded(items));
      } catch (_) {
        emit(AchievementError("Failed to load achievements"));
      }
    });
  }
}
