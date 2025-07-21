class UserModel {
  final int id;
  final String username;
  final String accessToken;

  UserModel({required this.id, required this.username, required this.accessToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      accessToken: json['access_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'access_token': accessToken,
    };
  }
}
