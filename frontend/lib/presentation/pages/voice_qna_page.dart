// File: frontend/lib/presentation/pages/voice_qna_page.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';

import '../../domain/entities/lesson.dart';

class VoiceQnAPage extends StatefulWidget {
  static const String routeName = '/voice-qna';
  final Lesson? lesson;

  const VoiceQnAPage({super.key, this.lesson});

  @override
  State<VoiceQnAPage> createState() => _VoiceQnAPageState();
}

class _VoiceQnAPageState extends State<VoiceQnAPage>
    with TickerProviderStateMixin {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isProcessing = false;
  bool _hasPermission = false;

  String? _questionText;
  String? _answerText;
  String? _recordingPath;

  final List<Map<String, dynamic>> _conversation = [];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    // Request permissions
    final status = await Permission.microphone.request();
    setState(() {
      _hasPermission = status == PermissionStatus.granted;
    });

    if (_hasPermission) {
      await _recorder!.openRecorder();
      await _player!.openPlayer();
    }
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final directory = await getTemporaryDirectory();
      _recordingPath = '${directory.path}/voice_question.aac';

      await _recorder!.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacADTS,
      );

      if (!mounted) return;

      setState(() {
        _isRecording = true;
      });

      _pulseController.repeat(reverse: true);
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to start recording: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await _recorder!.stopRecorder();
      _pulseController.stop();

      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      await _processVoiceQuestion();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to stop recording: $e')),
      );
    }
  }

  Future<void> _processVoiceQuestion() async {
    if (_recordingPath == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final file = File(_recordingPath!);
      if (!await file.exists()) {
        throw Exception('Recording file not found');
      }

      // Prepare multipart request
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/voice-qna');
      final request = http.MultipartRequest('POST', uri);

      // Add audio file
      request.files.add(
        await http.MultipartFile.fromPath('audio_file', file.path),
      );

      // Add lesson context if available
      if (widget.lesson != null) {
        request.fields['lesson_id'] = widget.lesson!.id.toString();
        request.fields['grade_level'] =
            '1'; // You can get this from user profile
      }

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (!mounted) return;

      if (response.statusCode == 200) {
        final result = json.decode(responseBody);

        if (result['success']) {
          setState(() {
            _questionText = result['question'];
            _answerText = result['answer'];

            _conversation.add({
              'type': 'question',
              'text': _questionText!,
              'timestamp': DateTime.now(),
            });

            _conversation.add({
              'type': 'answer',
              'text': _answerText!,
              'audio': result['audio_response'],
              'timestamp': DateTime.now(),
            });
          });

          // Play audio response
          await _playAudioResponse(result['audio_response']);
        } else {
          throw Exception(result['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error processing question: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _playAudioResponse(String base64Audio) async {
    if (base64Audio.isEmpty) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Decode base64 audio
      final audioData = base64Decode(base64Audio);

      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final audioPath = '${directory.path}/ai_response.mp3';
      final audioFile = File(audioPath);
      await audioFile.writeAsBytes(audioData);

      // Play the audio
      if (!mounted) return;
      setState(() {
        _isPlaying = true;
      });

      await _audioPlayer.play(DeviceFileSource(audioPath));

      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  Widget _buildConversationBubble(Map<String, dynamic> message) {
    final isQuestion = message['type'] == 'question';

    return Align(
      alignment: isQuestion ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isQuestion ? Colors.blue.shade100 : Colors.green.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isQuestion ? Colors.blue.shade300 : Colors.green.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isQuestion ? Icons.person : Icons.smart_toy,
                  size: 16,
                  color:
                      isQuestion ? Colors.blue.shade600 : Colors.green.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  isQuestion ? 'You' : 'AI Teacher',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isQuestion
                        ? Colors.blue.shade600
                        : Colors.green.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message['text'],
              style: const TextStyle(fontSize: 16),
            ),
            if (!isQuestion && message['audio'] != null) ...[
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _playAudioResponse(message['audio']),
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Play Audio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text(
          widget.lesson != null
              ? 'Ask about ${widget.lesson!.title}'
              : 'Voice Q&A with AI',
        ),
        backgroundColor: Colors.purple.shade400,
        foregroundColor: Colors.white,
        actions: [
          if (_conversation.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _conversation.clear();
                });
              },
              tooltip: 'Clear Conversation',
            ),
        ],
      ),
      body: Column(
        children: [
          // Conversation area
          Expanded(
            child: _conversation.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mic,
                          size: 80,
                          color: Colors.purple.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.lesson != null
                              ? 'Ask me anything about\n${widget.lesson!.title}!'
                              : 'Ask me anything!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.purple.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap and hold the microphone to speak',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _conversation.length,
                    itemBuilder: (context, index) {
                      return _buildConversationBubble(_conversation[index]);
                    },
                  ),
          ),

          // Recording controls
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (_isProcessing) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Processing your question...'),
                  const SizedBox(height: 16),
                ] else if (_isPlaying) ...[
                  const Icon(
                    Icons.volume_up,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text('Playing AI response...'),
                  const SizedBox(height: 16),
                ],

                // Record button
                GestureDetector(
                  onTapDown: (_) => _startRecording(),
                  onTapUp: (_) => _stopRecording(),
                  onTapCancel: () => _stopRecording(),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isRecording ? _pulseAnimation.value : 1.0,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording
                                ? Colors.red.shade400
                                : Colors.purple.shade400,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_isRecording ? Colors.red : Colors.purple)
                                        .withAlpha(77),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  _hasPermission
                      ? (_isRecording
                          ? 'Release to send question'
                          : 'Hold to ask a question')
                      : 'Microphone permission needed',
                  style: TextStyle(
                    color: _hasPermission ? Colors.grey.shade600 : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
