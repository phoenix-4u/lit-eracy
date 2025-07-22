part of 'content_bloc.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

class LoadLessons extends ContentEvent {
  final int grade;

  const LoadLessons(this.grade);

  @override
  List<Object> get props => [grade];
}