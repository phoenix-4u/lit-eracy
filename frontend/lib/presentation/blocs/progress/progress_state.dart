// # File: frontend/lib/presentation/blocs/progress/progress_state.dart

part of 'progress_bloc.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressUpdated extends ProgressState {
  final String contentId;
  final double completionPercentage;
  final int timeSpent;

  const ProgressUpdated({
    required this.contentId,
    required this.completionPercentage,
    required this.timeSpent,
  });

  @override
  List<Object> get props => [contentId, completionPercentage, timeSpent];
}

class ProgressLoaded extends ProgressState {
  final Progress progress;

  const ProgressLoaded({required this.progress});

  @override
  List<Object> get props => [progress];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError({required this.message});

  @override
  List<Object> get props => [message];
}
