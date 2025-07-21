import '../../data/repositories/content_repository.dart';
import '../../data/models/achievement_model.dart';

class FetchAchievementsUseCase {
  final ContentRepository _repo;
  FetchAchievementsUseCase(this._repo);

  Future<List<AchievementModel>> execute(int userId) {
    return _repo.fetchAchievements(userId);
  }
}
