part of 'ai_bloc.dart';

abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object> get props => [];
}

class GenerateTask extends AiEvent {
  final int lessonId;

  const GenerateTask({required this.lessonId});

  @override
  List<Object> get props => [lessonId];
}
