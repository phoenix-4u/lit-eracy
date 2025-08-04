// # File: frontend/lib/domain/entities/user.dart (Extended)

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name; // Added name property
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ??
          json['email']?.split('@')?.first ??
          'User', // Fallback to email prefix
      role: UserRole.values.firstWhere(
        (role) => role.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.student,
      ),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [id, email, name, role, createdAt, updatedAt];
}

enum UserRole {
  student,
  parent,
  teacher,
  admin,
}
