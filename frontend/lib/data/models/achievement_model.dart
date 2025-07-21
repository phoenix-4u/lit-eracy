class AchievementModel {
  final int id;
  final int userId;
  final String name;
  final DateTime earnedAt;

  AchievementModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.earnedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      earnedAt: DateTime.parse(json['earned_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'earned_at': earnedAt.toIso8601String(),
    };
  }
}
