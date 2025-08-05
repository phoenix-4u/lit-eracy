import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/api_service.dart';
import '../../domain/entities/lesson.dart';

class LessonPage extends StatefulWidget {
  static const String routeName = '/lesson';
  final Lesson lesson;
  const LessonPage({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final ApiService _api = GetIt.instance<ApiService>();
  bool _loading = true;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() => _loading = true);
    try {
      final resp = await _api.get('/api/tasks/lesson/${widget.lesson.id}');
      final List<dynamic> data = resp['data'] as List<dynamic>? ?? [];
      setState(() {
        _tasks = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tasks: $e')),
      );
    }
  }

  Future<void> _generateTask() async {
    setState(() => _loading = true);
    try {
      await _api.post('/api/lessons/${widget.lesson.id}/generate-task', {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generated new task')),
      );
      await _fetchTasks();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating task: $e')),
      );
    }
  }

  Future<void> _completeTask(int id) async {
    try {
      await _api.post('/api/tasks/$id/complete', {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task marked complete')),
      );
      await _fetchTasks();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTasks,
            tooltip: 'Refresh Tasks',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _generateTask,
            tooltip: 'Generate Task',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.lesson.content.isNotEmpty) ...[
                    Text(
                      widget.lesson.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'Tasks:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _tasks.isEmpty
                        ? const Center(child: Text('No tasks found'))
                        : ListView.builder(
                            itemCount: _tasks.length,
                            itemBuilder: (context, i) {
                              final task = _tasks[i];
                              final completed = task['is_completed'] == 1 ||
                                  task['is_completed'] == true;
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/task',
                                    arguments: {'taskId': task['id']},
                                  );
                                },
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    title: Text(task['title'] ?? ''),
                                    subtitle: Text(task['description'] ?? ''),
                                    trailing: completed
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : ElevatedButton(
                                            onPressed: () => _completeTask(
                                                task['id'] as int),
                                            child: const Text('Complete'),
                                          ),
                                  ),
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
