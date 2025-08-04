// ## File: frontend/lib/features/auth/data/models/user_model.dart (Final Corrected Version)

import '../../domain/entities/user.dart';
// import '../../domain/entities/user_role.dart';

// UserModel now perfectly mirrors the backend's UserResponse schema
class UserModel extends User {
  // Add the token, as it's part of the login flow data
  final String? token;

  const UserModel({
    required super.id,
    required super.name, // The entity uses 'name'
    required super.email,
    required super.role,
    required super.createdAt,
    required super.updatedAt,
    this.token,
  });

  // This factory now correctly parses the JSON from your Python backend
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Helper to parse string to UserRole enum
    UserRole roleFromString(String? role) {
      switch (role?.toUpperCase()) {
        case 'TEACHER':
          return UserRole.teacher;
        case 'PARENT':
          return UserRole.parent;
        case 'STUDENT':
        default:
          return UserRole.student;
      }
    }

    return UserModel(
      // The 'id' from the backend is an int, but our entity expects a String
      id: json['id'].toString(),
      // The backend sends 'full_name', we map it to our entity's 'name' field
      name: json['full_name'],
      email: json['email'],
      role: roleFromString(json['role']),
      // The backend sends dates as ISO strings, we parse them to DateTime
      // Defaulting to now() if the fields are missing, for robustness
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      // The token is not part of the /me response, so it will be null here, which is fine.
      token: json['access_token'],
    );
  }

  // The copyWith method must now match the User entity's signature
  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
    );
  }
}
