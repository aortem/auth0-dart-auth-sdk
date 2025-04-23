/// A model class representing the response received after a successful
/// passwordless OOB (out-of-band) verification request in Auth0.
///
/// This response contains tokens that allow the client to authenticate
/// and authorize subsequent requests.
///
/// Example JSON response:
/// ```json
/// {
///   "access_token": "ACCESS_TOKEN_HERE",
///   "id_token": "ID_TOKEN_HERE",
///   "refresh_token": "REFRESH_TOKEN_HERE",
///   "token_type": "Bearer",
///   "expires_in": 86400
/// }
/// ```
///
/// Example usage:
/// ```dart
/// final response = AortemAuth0VerifyOOBResponse.fromJson(json);
/// print(response.accessToken);
/// ```
class AortemAuth0VerifyOOBResponse {
  /// The access token used to authenticate API requests.
  final String accessToken;

  /// The ID token containing user identity claims.
  final String idToken;

  /// The refresh token used to obtain new access tokens (optional).
  final String? refreshToken;

  /// The type of the token (typically "Bearer").
  final String? tokenType;

  /// The lifetime in seconds of the access token.
  final int? expiresIn;

  /// Creates an instance of [AortemAuth0VerifyOOBResponse].
  AortemAuth0VerifyOOBResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  /// Creates an [AortemAuth0VerifyOOBResponse] instance from a JSON map.
  ///
  /// Throws a [FormatException] if required fields are missing or invalid.
  factory AortemAuth0VerifyOOBResponse.fromJson(Map<String, dynamic> json) {
    return AortemAuth0VerifyOOBResponse(
      accessToken: json['access_token'],
      idToken: json['id_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}
