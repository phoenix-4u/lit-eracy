part of 'points_bloc.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object> get props => [];
}

class LoadUserPoints extends PointsEvent {
  final String userId;

  const LoadUserPoints({required this.userId});

  @override
  List<Object> get props => [userId];
}
