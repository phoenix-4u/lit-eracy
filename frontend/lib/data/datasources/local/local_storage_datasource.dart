// # File: frontend/lib/data/datasources/local/local_storage_datasource.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/achievement.dart';
import '../../../core/error/exceptions.dart';

abstract class LocalStorageDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getCachedUser();
  Future<void> cacheLessons(List<Lesson> lessons);
  Future<List<Lesson>> getCachedLessons();
  Future<void> cacheAchievements(List<Achievement> achievements);
  Future<List<Achievement>> getCachedAchievements();
  Future<void> clearAll();
  Future<void> storeToken(String token);
  Future<String?> getToken();
  Future<void> storeRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final SharedPreferences sharedPreferences;

  static const String _userKey = 'cached_user';
  static const String _lessonsKey = 'cached_lessons';
  static const String _achievementsKey = 'cached_achievements';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  LocalStorageDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(User user) async {
    try {
      await sharedPreferences.setString(_userKey, json.encode(user.toJson()));
    } catch (e) {
      throw const CacheException('Failed to cache user data');
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      final userString = sharedPreferences.getString(_userKey);
      if (userString != null) {
        final userMap = json.decode(userString) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw const CacheException('Failed to get cached user data');
    }
  }

  @override
  Future<void> cacheLessons(List<Lesson> lessons) async {
    try {
      final lessonsJson = lessons.map((lesson) => lesson.toJson()).toList();
      await sharedPreferences.setString(_lessonsKey, json.encode(lessonsJson));
    } catch (e) {
      throw const CacheException('Failed to cache lessons');
    }
  }

  @override
  Future<List<Lesson>> getCachedLessons() async {
    try {
      final lessonsString = sharedPreferences.getString(_lessonsKey);
      if (lessonsString != null) {
        final lessonsList = json.decode(lessonsString) as List<dynamic>;
        return lessonsList
            .map((lessonMap) =>
                Lesson.fromJson(lessonMap as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException('Failed to get cached lessons');
    }
  }

  @override
  Future<void> cacheAchievements(List<Achievement> achievements) async {
    try {
      final achievementsJson =
          achievements.map((achievement) => achievement.toJson()).toList();
      await sharedPreferences.setString(
          _achievementsKey, json.encode(achievementsJson));
    } catch (e) {
      throw const CacheException('Failed to cache achievements');
    }
  }

  @override
  Future<List<Achievement>> getCachedAchievements() async {
    try {
      final achievementsString = sharedPreferences.getString(_achievementsKey);
      if (achievementsString != null) {
        final achievementsList =
            json.decode(achievementsString) as List<dynamic>;
        return achievementsList
            .map((achievementMap) =>
                Achievement.fromJson(achievementMap as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException('Failed to get cached achievements');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await sharedPreferences.remove(_userKey);
      await sharedPreferences.remove(_lessonsKey);
      await sharedPreferences.remove(_achievementsKey);
      await sharedPreferences.remove(_tokenKey);
      await sharedPreferences.remove(_refreshTokenKey);
    } catch (e) {
      throw const CacheException('Failed to clear cache');
    }
  }

  @override
  Future<void> storeToken(String token) async {
    try {
      await sharedPreferences.setString(_tokenKey, token);
    } catch (e) {
      throw const CacheException('Failed to store token');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(_tokenKey);
    } catch (e) {
      throw const CacheException('Failed to get token');
    }
  }

  @override
  Future<void> storeRefreshToken(String refreshToken) async {
    try {
      await sharedPreferences.setString(_refreshTokenKey, refreshToken);
    } catch (e) {
      throw const CacheException('Failed to store refresh token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return sharedPreferences.getString(_refreshTokenKey);
    } catch (e) {
      throw const CacheException('Failed to get refresh token');
    }
  }
}
