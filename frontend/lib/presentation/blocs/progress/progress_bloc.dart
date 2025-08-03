// # File: frontend/lib/presentation/blocs/progress/progress_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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

    // Mock progress update
    await Future.delayed(const Duration(seconds: 1));

    emit(ProgressUpdated(
      contentId: event.contentId,
      completionPercentage: event.completionPercentage,
      timeSpent: event.timeSpent,
    ));
  }

  Future<void> _onLoadProgress(
    LoadProgress event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());

    // Mock progress data
    final progressList = [
      {
        'id': 1,
        'content_id': 1,
        'completion_percentage': 75.0,
        'time_spent': 300,
        'is_completed': false,
      },
      {
        'id': 2,
        'content_id': 2,
        'completion_percentage': 100.0,
        'time_spent': 480,
        'is_completed': true,
      }
    ];

    emit(ProgressLoaded(progressList));
  }
}
