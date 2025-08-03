// # File: frontend/lib/presentation/blocs/content/content_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/content.dart';
import '../../../domain/usecases/fetch_lessons_usecase.dart';

// Events
abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

class LoadLessons extends ContentEvent {
  final int? grade;

  const LoadLessons({this.grade});

  @override
  List<Object> get props => [grade ?? 0];
}

class LoadContent extends ContentEvent {}

class RefreshContent extends ContentEvent {}

// States
abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<Lesson> lessons;
  final List<Content> content;

  const ContentLoaded({
    this.lessons = const [],
    this.content = const [],
  });

  @override
  List<Object> get props => [lessons, content];
}

class ContentError extends ContentState {
  final String message;

  const ContentError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final FetchLessonsUseCase getLessonsUseCase;

  ContentBloc({
    required this.getLessonsUseCase,
  }) : super(ContentInitial()) {
    on<LoadLessons>(_onLoadLessons);
    on<LoadContent>(_onLoadContent);
    on<RefreshContent>(_onRefreshContent);
  }

  Future<void> _onLoadLessons(
    LoadLessons event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());

    final result = await getLessonsUseCase(
      FetchLessonsParams(grade: event.grade),
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
    emit(ContentLoading());
    // Implementation for loading content
    emit(const ContentLoaded());
  }

  Future<void> _onRefreshContent(
    RefreshContent event,
    Emitter<ContentState> emit,
  ) async {
    // Implementation for refreshing content
    add(const LoadLessons());
  }
}
