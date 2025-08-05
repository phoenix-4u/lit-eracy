//File: frontend/lib/domain/entities/achievement.dart

import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final int id;
  final String title;
  final String description;
  final String iconName;
  final int pointsRequired;
  final String category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String rarity; // bronze, silver, gold, platinum
  final Map<String, dynamic>? criteria;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.pointsRequired,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    this.rarity = 'bronze',
    this.criteria,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      // For non-nullable fields, provide a sensible default if the key is missing or null.
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Unknown Achievement',
      description: json['description'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'default_icon',
      pointsRequired: json['points_required'] as int? ?? 0,
      category: json['category'] as String? ?? 'General',

      // Your existing null-safe checks are already good.
      isUnlocked: json['is_unlocked'] as bool? ?? false,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.tryParse(
              json['unlocked_at'] as String) // Use tryParse for safety
          : null,
      rarity: json['rarity'] as String? ?? 'bronze',

      // Your nullable Map check is also good.
      criteria: json['criteria'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_name': iconName,
      'points_required': pointsRequired,
      'category': category,
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'rarity': rarity,
      'criteria': criteria,
    };
  }

  Achievement copyWith({
    int? id,
    String? title,
    String? description,
    String? iconName,
    int? pointsRequired,
    String? category,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? rarity,
    Map<String, dynamic>? criteria,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rarity: rarity ?? this.rarity,
      criteria: criteria ?? this.criteria,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconName,
        pointsRequired,
        category,
        isUnlocked,
        unlockedAt,
        rarity,
        criteria,
      ];
}
