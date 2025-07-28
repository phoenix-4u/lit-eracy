class User {
  final String accessToken;
  final String tokenType;

  User({
    required this.accessToken,
    required this.tokenType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }

  // Helper method to get authorization header value
  String get authorizationHeader => '$tokenType $accessToken';

  @override
  String toString() {
    return 'User{accessToken: ${accessToken.substring(0, 10)}..., tokenType: $tokenType}';
  }
}
