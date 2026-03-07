/// Represents the response returned after a successful Auth0 user authentication.
class Auth0AuthenticateUserResponse {
  /// The access token issued by Auth0 for accessing APIs.
  final String accessToken;

  /// The ID token representing the authenticated user (JWT format).
  final String idToken;

  /// Optional: A refresh token to obtain new access tokens without re-authentication.
  final String? refreshToken;

  /// The type of token returned, typically "Bearer".
  final String tokenType;

  /// Optional: Time in seconds until the access token expires.
  final int? expiresIn;

  ///constructre
  Auth0AuthenticateUserResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    required this.tokenType,
    this.expiresIn,
  });

  /// Creates an instance from a JSON response.
  factory Auth0AuthenticateUserResponse.fromJson(Map<String, dynamic> json) {
    if (json['access_token'] == null ||
        json['id_token'] == null ||
        json['token_type'] == null) {
      throw FormatException('Missing required token fields in Auth0 response');
    }

    return Auth0AuthenticateUserResponse(
      accessToken: json['access_token'] as String,
      idToken: json['id_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int?,
    );
  }
}
