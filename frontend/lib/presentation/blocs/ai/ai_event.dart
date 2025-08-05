// File: frontend/lib/presentation/blocs/ai/ai_event.dart

part of 'ai_bloc.dart';

abstract class AIEvent {}

class GenerateTaskRequested extends AIEvent {
  final int lessonId;
  GenerateTaskRequested(this.lessonId);
}
