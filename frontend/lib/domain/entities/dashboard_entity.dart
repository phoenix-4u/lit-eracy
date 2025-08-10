// File: frontend/lib/domain/entities/dashboard_entity.dart

import 'package:equatable/equatable.dart';

class PointsEntity extends Equatable {
  final int knowledgeGems;
  final int wordCoins;
  final int imaginationSparks;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final String? lastActivityDate;

  const PointsEntity({
    required this.knowledgeGems,
    required this.wordCoins,
    required this.imaginationSparks,
    required this.totalPoints,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
  });

  @override
  List<Object?> get props => [
        knowledgeGems,
        wordCoins,
        imaginationSparks,
        totalPoints,
        currentStreak,
        longestStreak,
        lastActivityDate,
      ];
}

class LessonInfoEntity extends Equatable {
  final int id;
  final String title;
  final String subject;
  final int gradeLevel;
  final int pointsReward;
  final int estimatedDuration;

  const LessonInfoEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.gradeLevel,
    required this.pointsReward,
    required this.estimatedDuration,
  });

  @override
  List<Object> get props => [
        id,
        title,
        subject,
        gradeLevel,
        pointsReward,
        estimatedDuration,
      ];
}

class DashboardEntity extends Equatable {
  final int numLessons;
  final PointsEntity points;
  final List<LessonInfoEntity> recentLessons;
  final List<LessonInfoEntity> recommendedContent;

  const DashboardEntity({
    required this.numLessons,
    required this.points,
    required this.recentLessons,
    required this.recommendedContent,
  });

  // Factory method to create from data model
  factory DashboardEntity.fromModel(dynamic dashboardModel) {
    return DashboardEntity(
      numLessons: dashboardModel.numLessons,
      points: PointsEntity(
        knowledgeGems: dashboardModel.points.knowledgeGems,
        wordCoins: dashboardModel.points.wordCoins,
        imaginationSparks: dashboardModel.points.imaginationSparks,
        totalPoints: dashboardModel.points.totalPoints,
        currentStreak: dashboardModel.points.currentStreak,
        longestStreak: dashboardModel.points.longestStreak,
        lastActivityDate: dashboardModel.points.lastActivityDate,
      ),
      recentLessons: dashboardModel.recentLessons
          .map<LessonInfoEntity>((lesson) => LessonInfoEntity(
                id: lesson.id,
                title: lesson.title,
                subject: lesson.subject,
                gradeLevel: lesson.gradeLevel,
                pointsReward: lesson.pointsReward,
                estimatedDuration: lesson.estimatedDuration,
              ))
          .toList(),
      recommendedContent: dashboardModel.recommendedContent
          .map<LessonInfoEntity>((lesson) => LessonInfoEntity(
                id: lesson.id,
                title: lesson.title,
                subject: lesson.subject,
                gradeLevel: lesson.gradeLevel,
                pointsReward: lesson.pointsReward,
                estimatedDuration: lesson.estimatedDuration,
              ))
          .toList(),
    );
  }

  @override
  List<Object> get props =>
      [numLessons, points, recentLessons, recommendedContent];
}
