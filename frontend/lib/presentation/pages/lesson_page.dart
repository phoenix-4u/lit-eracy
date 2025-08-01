import 'package:flutter/material.dart';
import 'package:lit_eracy/domain/models/lesson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List<dynamic> tasks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/tasks/${widget.lesson.id}'),
      // Add auth headers if needed
    );
    if (response.statusCode == 200) {
      setState(() {
        tasks = json.decode(response.body);
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> completeTask(int taskId) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/tasks/$taskId/complete'),
      // Add auth headers if needed
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task completed!')),
      );
      fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.lesson.contentData ?? ''),
            const SizedBox(height: 24),
            Text('Tasks:', style: Theme.of(context).textTheme.titleMedium),
            loading
                ? const CircularProgressIndicator()
                : tasks.isEmpty
                    ? const Text('No tasks for this lesson.')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Card(
                            child: ListTile(
                              title: Text(task['title'] ?? ''),
                              subtitle: Text(task['description'] ?? ''),
                              trailing: task['is_completed'] == 1
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : ElevatedButton(
                                      onPressed: () => completeTask(task['id']),
                                      child: const Text('Complete'),
                                    ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
