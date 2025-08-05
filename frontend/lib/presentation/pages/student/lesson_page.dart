// # File: frontend/lib/presentation/pages/student/lesson_page.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/entities/lesson.dart';
import '../task_page.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List<dynamic> tasks = [];
  bool loading = true;
  final ApiService _apiService = GetIt.instance<ApiService>();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() => loading = true);
    try {
      final Map<String, dynamic> response = await _apiService.get(
        '/api/tasks/lesson/${widget.lesson.id}',
      );
      final List<dynamic> taskList = (response['data'] as List<dynamic>?) ?? [];
      setState(() {
        tasks = taskList;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tasks: $e')),
      );
      await generateTaskForLesson();
    }
  }

  Future<void> generateTaskForLesson() async {
    try {
      setState(() => loading = true);
      await _apiService.post(
        '/api/lessons/${widget.lesson.id}/generate-task',
        {},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generated new task!')),
      );
      await fetchTasks();
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate task: $e')),
      );
    }
  }

  Future<void> completeTask(int taskId) async {
    try {
      await _apiService.post('/api/tasks/$taskId/complete', {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task completed!')),
      );
      fetchTasks();
    } on ServerException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } on NetworkException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Network error: ${e.message}')));
    } on AuthenticationException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Auth error: ${e.message}')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: generateTaskForLesson,
            tooltip: 'Generate Task',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchTasks,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.lesson.content.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(widget.lesson.content),
                ),
              ),
            const SizedBox(height: 24),
            Text('Tasks:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : tasks.isEmpty
                      ? const Center(child: Text('No tasks for this lesson.'))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index] as Map<String, dynamic>;
                            final completed = task['is_completed'] == 1 ||
                                task['is_completed'] == true;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(task['title'] ?? ''),
                                subtitle: Text(task['description'] ?? ''),
                                trailing: completed
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : ElevatedButton(
                                        onPressed: () =>
                                            completeTask(task['id'] as int),
                                        child: const Text('Complete'),
                                      ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TaskPage(
                                        taskId: task['id'] as int,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
