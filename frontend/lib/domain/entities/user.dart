// # File: frontend/lib/domain/entities/user.dart

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final int? age;
  final int? grade;
  final String role;
  final String? parentEmail;
  final String? avatarUrl;
  final bool isActive;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.age,
    this.grade,
    required this.role,
    this.parentEmail,
    this.avatarUrl,
    required this.isActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      age: json['age'],
      grade: json['grade'],
      role: json['role'] ?? 'student',
      parentEmail: json['parent_email'],
      avatarUrl: json['avatar_url'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
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
      'parent_email': parentEmail,
      'avatar_url': avatarUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
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
        parentEmail,
        avatarUrl,
        isActive,
        createdAt,
      ];
}
