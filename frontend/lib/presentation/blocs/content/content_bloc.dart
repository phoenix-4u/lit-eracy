import 'package:bloc/bloc.dart';
import 'package:lit_eracy/domain/usecases/fetch_lessons_usecase.dart';
import 'package:lit_eracy/domain/models/lesson.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final FetchLessonsUseCase useCase;

  ContentBloc(this.useCase) : super(ContentInitial()) {
    on<LoadLessons>((event, emit) async {
      emit(ContentLoading());
      final result = await useCase.execute(event.grade);
      result.fold(
        (failure) => emit(ContentError(failure.message)),
        (lessons) => emit(ContentLoaded(lessons)),
      );
    });
  }
}
