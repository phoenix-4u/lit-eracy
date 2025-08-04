// # File: frontend/lib/presentation/blocs/content/content_state.dart (Fixed)

part of 'content_bloc.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInitial extends ContentState {
  const ContentInitial();
}

class ContentLoading extends ContentState {
  const ContentLoading();
}

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
