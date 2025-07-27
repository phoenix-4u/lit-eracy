class User {
  final String accessToken;
  final String tokenType;

  User({required this.accessToken, required this.tokenType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }
}
