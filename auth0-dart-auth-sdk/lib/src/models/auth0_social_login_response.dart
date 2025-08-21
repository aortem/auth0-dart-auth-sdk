/// Represents the response received after social authentication via Auth0.
class Auth0SocialLoginResponse {
  /// The access token provided by Auth0.
  final String accessToken;

  /// The ID token containing user identity information.
  final String idToken;

  /// Optional: The refresh token for obtaining new access tokens.
  final String? refreshToken;

  /// The type of token (e.g., "Bearer").
  final String tokenType;

  /// Optional: The duration (in seconds) until the token expires.
  final int? expiresIn;

  ///constructure
  Auth0SocialLoginResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    required this.tokenType,
    this.expiresIn,
  });

  /// Creates an instance from a JSON map.
  factory Auth0SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['access_token'] == null ||
        json['id_token'] == null ||
        json['token_type'] == null) {
      throw FormatException('Missing required fields in Auth0 response');
    }

    return Auth0SocialLoginResponse(
      accessToken: json['access_token'] as String,
      idToken: json['id_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int?,
    );
  }
}
