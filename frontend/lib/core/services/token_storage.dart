// # File: frontend/lib/core/services/token_storage.dart

abstract class TokenStorage {
  Future<void> storeToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> storeRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();
  Future<bool> hasToken();
}

class TokenStorageImpl implements TokenStorage {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  TokenStorageImpl(this._prefs);

  @override
  Future<void> storeToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _prefs.remove(_tokenKey);
  }

  @override
  Future<void> storeRefreshToken(String refreshToken) async {
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await _prefs.remove(_refreshTokenKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
