// # File: frontend/lib/presentation/blocs/content/content_event.dart

import 'package:equatable/equatable.dart';

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
