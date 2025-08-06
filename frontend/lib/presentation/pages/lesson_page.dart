import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/api_service.dart';
import '../../domain/entities/lesson.dart';
import 'task_page.dart';
import 'voice_qna_page.dart';

class LessonPage extends StatefulWidget {
  static const String routeName = '/lesson';
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

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
      final data = resp['data'] as List<dynamic>? ?? [];
      setState(() {
        _tasks = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading tasks: $e')));
    }
  }

  Future<void> _generateTask() async {
    setState(() => _loading = true);
    try {
      await _api.post('/api/lessons/${widget.lesson.id}/generate-task', {});
      await _fetchTasks();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Generated new task')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating task: $e')));
    }
  }

  Widget _buildSummary(String content) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade50, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.teal.shade200, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: MarkdownBody(
        data: content,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
          p: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
          listBullet: const TextStyle(fontSize: 16, color: Colors.teal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.lesson.title;
    final content = widget.lesson.content;
    // Take the first non-empty line as summary
    String summary = '';
    for (final line in content.split('\n')) {
      if (line.trim().isNotEmpty) {
        summary = line.trim();
        break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VoiceQnAPage(lesson: widget.lesson),
                ),
              );
            },
            tooltip: 'Voice Q&A',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateTask,
        backgroundColor: Colors.teal,
        tooltip: 'Generate Task',
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchTasks,
              color: Colors.teal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lesson Summary',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSummary('**$title**\n\n$summary'),
                    const SizedBox(height: 24),
                    Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _tasks.isEmpty
                        ? const Center(child: Text('No tasks found'))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _tasks.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              final completed =
                                  task['is_completed'] == 1 ||
                                  task['is_completed'] == true;
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            TaskPage(taskId: task['id']),
                                      ),
                                    );
                                  },
                                  title: Text(task['title'] ?? ''),
                                  subtitle: Text(task['description'] ?? ''),
                                  trailing: completed
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
