// # File: frontend/lib/presentation/blocs/content/content_event.dart

part of 'content_bloc.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class LoadContent extends ContentEvent {
  final String? subject;
  final int? gradeLevel;

  const LoadContent({this.subject, this.gradeLevel});

  @override
  List<Object?> get props => [subject, gradeLevel];
}

class LoadLessons extends ContentEvent {
  final String? subject;
  final int? gradeLevel;

  const LoadLessons({this.subject, this.gradeLevel});

  @override
  List<Object?> get props => [subject, gradeLevel];
}
