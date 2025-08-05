// File: frontend/lib/presentation/blocs/ai/ai_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/ai/generate_task_for_lesson.dart';
import '../../../domain/entities/task.dart';
import '../../../core/error/failures.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AIBloc extends Bloc<AIEvent, AIState> {
  final GenerateTaskForLesson generateUseCase;

  AIBloc({required this.generateUseCase}) : super(AIInitial()) {
    on<GenerateTaskRequested>(_onGenerateTask);
  }

  Future<void> _onGenerateTask(
      GenerateTaskRequested event, Emitter<AIState> emit) async {
    emit(AILoading());
    final result = await generateUseCase(event.lessonId);
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (task) => emit(AILoaded(task)),
    );
  }
}
