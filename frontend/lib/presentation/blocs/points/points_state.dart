part of 'points_bloc.dart';

abstract class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object> get props => [];
}

class PointsInitial extends PointsState {}

class PointsLoading extends PointsState {}

class PointsLoaded extends PointsState {
  final UserPoints points;

  const PointsLoaded({required this.points});

  @override
  List<Object> get props => [points];
}

class PointsError extends PointsState {
  final String message;

  const PointsError({required this.message});

  @override
  List<Object> get props => [message];
}
