import 'package:flutter/material.dart';
import '../../data/models/lesson_model.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  const LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(lesson.title),
        subtitle: Text('Grade ${lesson.grade}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LessonPage(lesson: lesson)),
          );
        },
      ),
    );
  }
}
