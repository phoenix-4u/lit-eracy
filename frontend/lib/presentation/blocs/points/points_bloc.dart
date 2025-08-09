
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/user_points.dart';
import '../../../../domain/usecases/user/get_user_points_usecase.dart';

part 'points_event.dart';
part 'points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final GetUserPointsUseCase getUserPointsUseCase;

  PointsBloc({required this.getUserPointsUseCase}) : super(PointsInitial()) {
    on<LoadUserPoints>(_onLoadUserPoints);
  }

  Future<void> _onLoadUserPoints(
    LoadUserPoints event,
    Emitter<PointsState> emit,
  ) async {
    emit(PointsLoading());
    final result = await getUserPointsUseCase(event.userId);
    result.fold(
      (failure) => emit(PointsError(message: failure.toString())),
      (points) => emit(PointsLoaded(points: points)),
    );
  }
}
