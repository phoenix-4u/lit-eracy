
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lit_eracy/domain/entities/task.dart';
import 'package:lit_eracy/domain/usecases/ai/generate_task_for_lesson.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  final GenerateTaskForLesson generateTaskForLesson;

  AiBloc({required this.generateTaskForLesson}) : super(AiInitial()) {
    on<GenerateTask>((event, emit) async {
      emit(AiLoading());
      final failureOrTask = await generateTaskForLesson(event.lessonId);
      failureOrTask.fold(
        (failure) => emit(const AiError(message: 'Failed to generate task')),
        (task) => emit(AiLoaded(task: task)),
      );
    });
  }
}
