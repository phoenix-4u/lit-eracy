// # File: frontend/lib/data/datasources/local/local_storage_datasource.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/achievement.dart';
import '../../../core/error/exceptions.dart';

abstract class LocalStorageDataSource {
  Future<void> storeToken(String token);
  Future<String?> getToken();
  Future<void> storeRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> cacheUser(User user);
  Future<User?> getCachedUser();
  Future<void> cacheLessons(List<Lesson> lessons);
  Future<List<Lesson>> getCachedLessons();
  Future<void> cacheAchievements(List<Achievement> achievements);
  Future<List<Achievement>> getCachedAchievements();
  Future<void> clearAll();
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final SharedPreferences sharedPreferences;

  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'cached_user';
  static const String lessonsKey = 'cached_lessons';
  static const String achievementsKey = 'cached_achievements';

  LocalStorageDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> storeToken(String token) async {
    await sharedPreferences.setString(tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(tokenKey);
  }

  @override
  Future<void> storeRefreshToken(String refreshToken) async {
    await sharedPreferences.setString(refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(refreshTokenKey);
  }

  @override
  Future<void> cacheUser(User user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(userKey, userJson);
  }

  @override
  Future<User?> getCachedUser() async {
    final userJsonString = sharedPreferences.getString(userKey);
    if (userJsonString != null) {
      try {
        final userJson = json.decode(userJsonString);
        return User.fromJson(userJson);
      } catch (e) {
        throw const CacheException('Failed to parse cached user');
      }
    }
    return null;
  }

  @override
  Future<void> cacheLessons(List<Lesson> lessons) async {
    final lessonsJson =
        json.encode(lessons.map((lesson) => lesson.toJson()).toList());
    await sharedPreferences.setString(lessonsKey, lessonsJson);
  }

  @override
  Future<List<Lesson>> getCachedLessons() async {
    final lessonsJsonString = sharedPreferences.getString(lessonsKey);
    if (lessonsJsonString != null) {
      try {
        final lessonsJson = json.decode(lessonsJsonString) as List;
        return lessonsJson.map((json) => Lesson.fromJson(json)).toList();
      } catch (e) {
        throw const CacheException('Failed to parse cached lessons');
      }
    }
    throw const CacheException('No cached lessons found');
  }

  @override
  Future<void> cacheAchievements(List<Achievement> achievements) async {
    final achievementsJson = json.encode(
        achievements.map((achievement) => achievement.toJson()).toList());
    await sharedPreferences.setString(achievementsKey, achievementsJson);
  }

  @override
  Future<List<Achievement>> getCachedAchievements() async {
    final achievementsJsonString = sharedPreferences.getString(achievementsKey);
    if (achievementsJsonString != null) {
      try {
        final achievementsJson = json.decode(achievementsJsonString) as List;
        return achievementsJson
            .map((json) => Achievement.fromJson(json))
            .toList();
      } catch (e) {
        throw const CacheException('Failed to parse cached achievements');
      }
    }
    throw const CacheException('No cached achievements found');
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.remove(tokenKey);
    await sharedPreferences.remove(refreshTokenKey);
    await sharedPreferences.remove(userKey);
    await sharedPreferences.remove(lessonsKey);
    await sharedPreferences.remove(achievementsKey);
  }
}
