// File: frontend/lib/presentation/pages/task_page.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/api_service.dart';

class TaskPage extends StatefulWidget {
  static const String routeName = '/task';
  final int taskId;
  const TaskPage({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final ApiService _api = GetIt.instance<ApiService>();
  bool _loading = true;
  Map<String, dynamic>? _task;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    setState(() => _loading = true);
    try {
      final resp = await _api.get('/api/tasks/${widget.taskId}');
      Map<String, dynamic>? data;
      if (resp['data'] is Map<String, dynamic>) {
        data = resp['data'] as Map<String, dynamic>;
      } else {
        data = resp.cast<String, dynamic>();
      }
      setState(() {
        _task = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading task: $e')),
      );
    }
  }

  Future<void> _completeTask() async {
    try {
      await _api.post('/api/tasks/${widget.taskId}/complete', {});
      if (!mounted) return;
      await _loadTask();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task marked complete')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _task?['title'] as String? ?? 'Task Details';
    final desc = _task?['description'] as String? ?? '';
    final completed =
        _task?['is_completed'] == 1 || _task?['is_completed'] == true;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  Text(desc, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  completed
                      ? const Text('Status: Completed',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold))
                      : ElevatedButton(
                          onPressed: _completeTask,
                          child: const Text('Mark as Complete'),
                        ),
                ],
              ),
            ),
    );
  }
}
