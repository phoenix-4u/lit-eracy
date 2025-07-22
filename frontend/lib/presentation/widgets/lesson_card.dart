import 'package:flutter/material.dart';
import 'package:lit_eracy/domain/models/lesson.dart';
import 'package:lit_eracy/presentation/pages/lesson_page.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
