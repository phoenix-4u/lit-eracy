part of 'content_bloc.dart';

abstract class ContentState {}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<LessonModel> lessons;
  ContentLoaded(this.lessons);
}

class ContentError extends ContentState {
  final String message;
  ContentError(this.message);
}
