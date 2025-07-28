import 'package:flutter/material.dart';
import 'package:lit_eracy/domain/models/lesson.dart';

class LessonPage extends StatelessWidget {
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(lesson.contentData ?? ''),
      ),
    );
  }
}
