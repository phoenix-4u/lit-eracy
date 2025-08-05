// File: frontend/lib/presentation/blocs/ai/ai_state.dart

part of 'ai_bloc.dart';

abstract class AIState {}

class AIInitial extends AIState {}

class AILoading extends AIState {}

class AILoaded extends AIState {
  final Task task;
  AILoaded(this.task);
}

class AIError extends AIState {
  final String message;
  AIError(this.message);
}
