import 'package:flutter/material.dart';
import '../../data/models/lesson_model.dart';

class LessonPage extends StatelessWidget {
  final LessonModel lesson;
  const LessonPage({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(lesson.content),
      ),
    );
  }
}
