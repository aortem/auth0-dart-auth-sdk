/// Represents the response returned after verifying an OTP (One-Time Password)
/// using Auth0.
///
/// This response typically includes access and ID tokens used for
/// authentication and authorization purposes, along with optional tokens like
/// a refresh token.
///
/// Example response from Auth0:
/// ```json
/// {
///   "access_token": "abc123",
///   "id_token": "xyz456",
///   "refresh_token": "refresh789",
///   "token_type": "Bearer",
///   "expires_in": 3600
/// }
/// ```
class Auth0VerifyOTPResponse {
  /// The access token used for making authenticated API requests.
  final String accessToken;

  /// The ID token which contains user identity information.
  final String idToken;

  /// An optional token that can be used to refresh the access token.
  final String? refreshToken;

  /// The type of token returned (usually "Bearer").
  final String? tokenType;

  /// The time in seconds until the access token expires.
  final int? expiresIn;

  /// Constructs a new [Auth0VerifyOTPResponse].
  Auth0VerifyOTPResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  /// Creates an instance of [Auth0VerifyOTPResponse] from a JSON map.
  factory Auth0VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    return Auth0VerifyOTPResponse(
      accessToken: json['access_token'],
      idToken: json['id_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}
