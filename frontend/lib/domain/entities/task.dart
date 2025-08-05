import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final int lessonId;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.lessonId,
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted];
}
