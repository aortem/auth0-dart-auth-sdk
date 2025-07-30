/// The response received from Auth0's `/oauth/token` endpoint after a successful token request.
///
/// This class represents the successful response from Auth0 when requesting tokens
/// through various OAuth 2.0 flows. The fields included in the response depend on
/// the grant type used and the scopes requested.
///
/// Example JSON response:
/// ```json
/// {
///   "access_token": "eyJ...",
///   "id_token": "eyJ...",
///   "refresh_token": "eyJ...",
///   "token_type": "Bearer",
///   "expires_in": 86400
/// }
/// ```
///
/// Example usage:
/// ```dart
/// final response = AortemAuth0GetTokenResponse.fromJson(jsonData);
/// print('Access Token: ${response.accessToken}');
/// if (response.idToken != null) {
///   print('ID Token: ${response.idToken}');
/// }
/// ```
class AortemAuth0GetTokenResponse {
  /// The access token issued by Auth0.
  ///
  /// This token is used to authenticate requests to protected resources/APIs.
  /// Always present in successful responses.
  final String accessToken;

  /// The ID token issued by Auth0 (when using OpenID Connect).
  ///
  /// Present when the 'openid' scope was requested and the grant type supports it.
  /// This is a JWT containing user profile information.
  final String? idToken;

  /// The refresh token issued by Auth0.
  ///
  /// Present when the 'offline_access' scope was requested and the grant type
  /// supports issuing refresh tokens. Used to obtain new access tokens when they expire.
  final String? refreshToken;

  /// The type of token issued.
  ///
  /// Typically "Bearer" for most OAuth 2.0 implementations.
  /// Always present in successful responses.
  final String tokenType;

  /// The lifetime in seconds of the access token.
  ///
  /// Indicates when the access token will expire. Not present for all grant types.
  final int? expiresIn;

  /// Creates a new token response instance from a JSON map.
  ///
  /// The [json] parameter should contain the parsed response from Auth0's
  /// `/oauth/token` endpoint.
  ///
  /// Throws if required fields (access_token, token_type) are missing.
  factory AortemAuth0GetTokenResponse.fromJson(Map<String, dynamic> json) {
    return AortemAuth0GetTokenResponse(
      accessToken: json['access_token'],
      idToken: json['id_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }

  /// Creates a new token response instance directly.
  ///
  /// [accessToken] and [tokenType] are required as they are always present
  /// in successful responses from Auth0. Other fields are optional depending
  /// on the grant type and scopes used.
  AortemAuth0GetTokenResponse({
    required this.accessToken,
    this.idToken,
    this.refreshToken,
    required this.tokenType,
    this.expiresIn,
  });
}
