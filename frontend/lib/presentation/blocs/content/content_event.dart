// # File: frontend/lib/presentation/blocs/content/content_event.dart (Fixed)

part of 'content_bloc.dart';

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

class LoadContent extends ContentEvent {
  const LoadContent();
}

class RefreshContent extends ContentEvent {
  const RefreshContent();
}
