class TokensAuthData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const TokensAuthData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const expiresInKey = 'expires_in';

  static TokensAuthData fromJson(Map<String, dynamic> json) {
    return TokensAuthData(
      accessToken: json[accessTokenKey],
      refreshToken: json[refreshTokenKey],
      expiresIn: json[expiresInKey],
    );
  }
}
