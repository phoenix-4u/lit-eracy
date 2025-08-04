// # File: frontend/lib/presentation/blocs/content/content_bloc.dart (Fixed)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/content.dart';
import '../../../domain/usecases/content/get_lessons_usecase.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final GetLessonsUseCase getLessonsUseCase;

  ContentBloc({required this.getLessonsUseCase})
      : super(const ContentInitial()) {
    on<LoadLessons>(_onLoadLessons);
    on<LoadContent>(_onLoadContent);
    on<RefreshContent>(_onRefreshContent);
  }

  Future<void> _onLoadLessons(
    LoadLessons event,
    Emitter<ContentState> emit,
  ) async {
    emit(const ContentLoading());

    final result = await getLessonsUseCase(
      GetLessonsParams(grade: event.grade),
    );

    result.fold(
      (failure) => emit(ContentError(message: failure.message)),
      (lessons) => emit(ContentLoaded(lessons: lessons)),
    );
  }

  Future<void> _onLoadContent(
    LoadContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(const ContentLoading());
    // Implementation for loading general content
    // This would require a GetContentUseCase
    emit(const ContentLoaded(lessons: [], content: []));
  }

  Future<void> _onRefreshContent(
    RefreshContent event,
    Emitter<ContentState> emit,
  ) async {
    // Refresh implementation
    add(const LoadLessons());
  }
}
