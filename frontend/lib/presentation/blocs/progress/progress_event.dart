// # File: frontend/lib/presentation/blocs/progress/progress_event.dart

part of 'progress_bloc.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object> get props => [];
}

class UpdateProgress extends ProgressEvent {
  final String userId;
  final String contentId;
  final double completionPercentage;
  final int timeSpent;

  const UpdateProgress({
    required this.userId,
    required this.contentId,
    required this.completionPercentage,
    required this.timeSpent,
  });

  @override
  List<Object> get props =>
      [userId, contentId, completionPercentage, timeSpent];
}

class LoadProgress extends ProgressEvent {
  final String userId;

  const LoadProgress({required this.userId});

  @override
  List<Object> get props => [userId];
}
