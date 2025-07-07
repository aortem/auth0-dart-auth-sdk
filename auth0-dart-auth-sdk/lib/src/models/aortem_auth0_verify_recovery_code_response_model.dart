/// Response model for successful recovery code verification
///
/// Contains the authentication tokens returned by Auth0 after
/// successfully verifying a recovery code
class AortemAuth0VerifyRecoveryCodeResponse {
  /// Access token for authorized API requests
  /// This is a JWT containing user claims
  /// Required for all authenticated requests
  final String accessToken;

  /// ID token containing user identity information
  /// This is a JWT with standard OIDC claims
  /// Used for client-side authentication
  final String idToken;

  /// Optional refresh token for obtaining new access tokens
  /// May be null depending on Auth0 configuration
  /// Used for long-lived sessions
  final String? refreshToken;

  /// Token type (typically "Bearer")
  /// Describes how the token should be used
  /// Usually "Bearer" for OAuth 2.0
  final String? tokenType;

  /// Expiration time of access token in seconds
  /// Indicates when the access token will expire
  /// Null if token doesn't expire
  final int? expiresIn;

  /// Constructs a recovery verification response
  ///
  /// Parameters:
  ///   [accessToken] - Required JWT access token
  ///   [idToken] - Required JWT ID token
  ///   [refreshToken] - Optional refresh token
  ///   [tokenType] - Optional token type (default "Bearer")
  ///   [expiresIn] - Optional expiration in seconds
  AortemAuth0VerifyRecoveryCodeResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  /// Creates a response instance from JSON data
  ///
  /// Parameters:
  ///   [json] - Map containing the JSON response from Auth0
  ///
  /// Returns:
  ///   New [AortemAuth0VerifyRecoveryCodeResponse] instance
  ///
  /// Expected JSON structure:
  /// {
  ///   "access_token": "...",
  ///   "id_token": "...",
  ///   "refresh_token": "...", // optional
  ///   "token_type": "...", // optional
  ///   "expires_in": 3600 // optional
  /// }
  factory AortemAuth0VerifyRecoveryCodeResponse.fromJson(
      Map<String, dynamic> json) {
    return AortemAuth0VerifyRecoveryCodeResponse(
      // Extract required access token
      accessToken: json['access_token'],

      // Extract required ID token
      idToken: json['id_token'],

      // Extract optional refresh token
      refreshToken: json['refresh_token'],

      // Extract optional token type
      tokenType: json['token_type'],

      // Extract optional expiration
      expiresIn: json['expires_in'],
    );
  }
}
