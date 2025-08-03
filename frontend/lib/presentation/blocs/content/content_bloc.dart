// # File: frontend/lib/presentation/blocs/content/content_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/content/get_lessons_usecase.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final GetLessonsUseCase _getLessonsUseCase;

  ContentBloc(this._getLessonsUseCase) : super(ContentInitial()) {
    on<LoadContent>(_onLoadContent);
    on<LoadLessons>(_onLoadLessons);
  }

  Future<void> _onLoadContent(
    LoadContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());

    // Mock content data
    final content = [
      {
        'id': 1,
        'title': 'Fun with Numbers',
        'subject': 'Math',
        'grade_level': 1,
        'difficulty_level': 1,
        'points_reward': 10,
        'estimated_duration': 5
      },
      {
        'id': 2,
        'title': 'Alphabet Adventures',
        'subject': 'English',
        'grade_level': 1,
        'difficulty_level': 1,
        'points_reward': 10,
        'estimated_duration': 8
      }
    ];

    emit(ContentLoaded(content));
  }

  Future<void> _onLoadLessons(
    LoadLessons event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());

    // Mock lessons data
    final lessons = [
      {
        'id': 1,
        'title': 'Counting 1-10',
        'subject': 'Math',
        'grade_level': event.gradeLevel ?? 1,
        'completed': false,
      },
      {
        'id': 2,
        'title': 'Letter Recognition',
        'subject': 'English',
        'grade_level': event.gradeLevel ?? 1,
        'completed': false,
      }
    ];

    emit(ContentLoaded(lessons));
  }
}
