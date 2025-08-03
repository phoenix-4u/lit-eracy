// # File: frontend/lib/domain/entities/user.dart

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? fullName;
  final int? age;
  final int? grade;
  final String role;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? profileImage;
  final Map<String, dynamic>? preferences;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.age,
    this.grade,
    required this.role,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.profileImage,
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      age: json['age'] as int?,
      grade: json['grade'] as int?,
      role: json['role'] as String? ?? 'student',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      profileImage: json['profile_image'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'age': age,
      'grade': grade,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'profile_image': profileImage,
      'preferences': preferences,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? fullName,
    int? age,
    int? grade,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? profileImage,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      profileImage: profileImage ?? this.profileImage,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        fullName,
        age,
        grade,
        role,
        createdAt,
        updatedAt,
        isActive,
        profileImage,
        preferences,
      ];

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, role: $role)';
  }
}
