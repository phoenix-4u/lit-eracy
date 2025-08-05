part of 'ai_bloc.dart';

abstract class AiState extends Equatable {
  const AiState();

  @override
  List<Object> get props => [];
}

class AiInitial extends AiState {}

class AiLoading extends AiState {}

class AiLoaded extends AiState {
  final Task task;

  const AiLoaded({required this.task});

  @override
  List<Object> get props => [task];
}

class AiError extends AiState {
  final String message;

  const AiError({required this.message});

  @override
  List<Object> get props => [message];
}
