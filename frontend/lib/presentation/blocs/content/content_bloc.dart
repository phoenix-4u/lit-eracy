'''import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lit_eracy/domain/usecases/fetch_lessons_usecase.dart';

import '../../models/lesson_model.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final FetchLessonsUseCase fetchLessonsUseCase;

  ContentBloc(this.fetchLessonsUseCase) : super(ContentInitial()) {
    on<LoadLessons>((event, emit) async {
      emit(ContentLoading());
      try {
        final lessons = await fetchLessonsUseCase.call(event.grade);
        emit(ContentLoaded(lessons));
      } catch (e) {
        emit(ContentError('Failed to load lessons'));
      }
    });
  }
}''