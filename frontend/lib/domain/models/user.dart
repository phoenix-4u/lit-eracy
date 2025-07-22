class User {
  final int id;
  final String username;
  final String accessToken;

  User({
    required this.id,
    required this.username,
    required this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      accessToken: json['access_token'] as String,
    );
  }
}
