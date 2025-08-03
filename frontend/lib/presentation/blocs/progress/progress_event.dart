// # File: frontend/lib/presentation/blocs/progress/progress_event.dart

part of 'progress_event.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgress extends ProgressEvent {
  final int userId;

  const LoadProgress(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateProgress extends ProgressEvent {
  final int contentId;
  final double completionPercentage;
  final int timeSpent;
  final double? score;

  const UpdateProgress({
    required this.contentId,
    required this.completionPercentage,
    required this.timeSpent,
    this.score,
  });

  @override
  List<Object?> get props =>
      [contentId, completionPercentage, timeSpent, score];
}
