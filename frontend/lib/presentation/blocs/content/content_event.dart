part of 'content_bloc.dart';

abstract class ContentEvent {}

class LoadLessons extends ContentEvent {
  final int grade;
  LoadLessons(this.grade);
}
