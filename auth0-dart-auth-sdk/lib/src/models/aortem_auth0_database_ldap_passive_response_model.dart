/// Represents the response from passive authentication
class AortemAuth0DatabaseAdLdapPassiveResponse {
  /// The access token provided by Auth0
  final String accessToken;

  /// The ID token containing user identity
  final String idToken;

  /// Optional refresh token
  final String? refreshToken;

  /// The type of token (e.g., "Bearer")
  final String tokenType;

  /// Optional expiration time in seconds
  final int? expiresIn;

  ///constructure
  AortemAuth0DatabaseAdLdapPassiveResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    required this.tokenType,
    this.expiresIn,
  });

  /// Creates an instance from JSON
  factory AortemAuth0DatabaseAdLdapPassiveResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json['access_token'] == null ||
        json['id_token'] == null ||
        json['token_type'] == null) {
      throw FormatException('Missing required fields in Auth0 response');
    }

    return AortemAuth0DatabaseAdLdapPassiveResponse(
      accessToken: json['access_token'] as String,
      idToken: json['id_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int?,
    );
  }
}
