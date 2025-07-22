// frontend/lib/domain/entities/user.dart

class User {
  final int id;
  final String username;
  final String email;
  final String? fullName;
  final int? age;
  final String token;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.age,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'] as int,
      username: json['user']['username'] as String,
      email: json['user']['email'] as String,
      fullName: json['user']['full_name'] as String?,
      age: json['user']['age'] as int?,
      token: json['access_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'username': username,
        'email': email,
        if (fullName != null) 'full_name': fullName,
        if (age != null) 'age': age,
      },
      'access_token': token,
    };
  }
}
