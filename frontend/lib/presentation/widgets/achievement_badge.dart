import 'package:flutter/material.dart';
import 'package:lit_eracy/domain/models/achievement.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  const AchievementBadge({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
        const SizedBox(height: 4),
        Text(achievement.name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
