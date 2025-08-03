// # File: frontend/lib/presentation/blocs/progress/progress_state.dart

part of 'progress_bloc.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final List<dynamic> progressData;

  const ProgressLoaded(this.progressData);

  @override
  List<Object> get props => [progressData];
}

class ProgressUpdated extends ProgressState {
  final String message;

  const ProgressUpdated(this.message);

  @override
  List<Object> get props => [message];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object> get props => [message];
}
