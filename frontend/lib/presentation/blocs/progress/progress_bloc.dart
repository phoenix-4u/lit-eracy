// # File: frontend/lib/presentation/blocs/progress/progress_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/progress.dart';
import '../../../domain/usecases/progress/update_progress_usecase.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final UpdateProgressUseCase _updateProgressUseCase;

  ProgressBloc(this._updateProgressUseCase) : super(ProgressInitial()) {
    on<UpdateProgress>(_onUpdateProgress);
    on<LoadProgress>(_onLoadProgress);
  }

  Future<void> _onUpdateProgress(
    UpdateProgress event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());

    final result = await _updateProgressUseCase(UpdateProgressParams(
      userId: event.userId,
      contentId: event.contentId,
      completionPercentage: event.completionPercentage,
      timeSpent: event.timeSpent,
    ));

    result.fold(
      (failure) => emit(ProgressError(message: failure.message)),
      (_) => emit(ProgressUpdated(
        contentId: event.contentId,
        completionPercentage: event.completionPercentage,
        timeSpent: event.timeSpent,
      )),
    );
  }

  Future<void> _onLoadProgress(
    LoadProgress event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());
    // Implementation for loading user progress
    // This would require a GetUserProgressUseCase which isn't implemented yet
    emit(ProgressInitial());
  }
}
