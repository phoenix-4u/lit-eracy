import '../../data/repositories/content_repository.dart';
import '../../data/models/lesson_model.dart';

class FetchLessonsUseCase {
  final ContentRepository _repo;

  FetchLessonsUseCase(this._repo);

  Future<List<LessonModel>> execute(int grade) {
    return _repo.fetchLessons(grade);
  }
}
