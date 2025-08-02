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
