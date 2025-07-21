import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_lessons_usecase.dart';
import '../../../data/models/lesson_model.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final FetchLessonsUseCase _useCase;

  ContentBloc(FetchLessonsUseCase useCase)
      : _useCase = useCase,
        super(ContentInitial()) {
    on<LoadLessons>((event, emit) async {
      emit(ContentLoading());
      try {
        final lessons = await _useCase.execute(event.grade);
        emit(ContentLoaded(lessons));
      } catch (e) {
        emit(ContentError('Failed to load lessons'));
      }
    });
  }
}
