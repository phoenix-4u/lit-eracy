import 'package:flutter/material.dart';
import '../../data/models/achievement_model.dart';

class AchievementBadge extends StatelessWidget {
  final AchievementModel achievement;
  const AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.emoji_events, size: 48, color: Colors.amber),
        SizedBox(height: 4),
        Text(achievement.name, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
