/// Represents the successful response from verifying a multi-factor authentication (MFA) challenge with Auth0.
///
/// This class encapsulates the tokens returned by Auth0 after successfully verifying
/// an MFA challenge. It includes the standard OAuth 2.0 tokens along with OpenID Connect
/// identity tokens.
///
/// Example usage:
/// ```dart
/// final response = Auth0MultiFactorVerifyResponse.fromJson(jsonData);
/// print('Access Token: ${response.accessToken}');
/// print('ID Token: ${response.idToken}');
/// ```
class Auth0MultiFactorVerifyResponse {
  /// The OAuth 2.0 access token used to authenticate API requests.
  ///
  /// This token should be used to authorize requests to protected resources.
  /// It typically has a limited lifetime as indicated by [expiresIn].
  final String accessToken;

  /// The OpenID Connect ID token containing user profile information.
  ///
  /// This JWT contains claims about the authenticated user and should be validated
  /// before use. It can be decoded to obtain user information.
  final String idToken;

  /// The OAuth 2.0 refresh token that can be used to obtain new access tokens.
  ///
  /// This token is optional and may be null depending on the Auth0 tenant configuration
  /// and the scopes requested during authentication. When present, it can be used
  /// to get new access tokens without requiring the user to re-authenticate.
  final String? refreshToken;

  /// The type of token returned (typically "Bearer").
  ///
  /// This indicates how the access token should be used when making API requests.
  final String? tokenType;

  /// The lifetime in seconds of the access token.
  ///
  /// This indicates when the access token will expire. Applications should use
  /// this value to determine when to refresh the token.
  final int? expiresIn;

  /// Creates an [Auth0MultiFactorVerifyResponse] instance.
  ///
  /// [accessToken] and [idToken] are required, while other fields are optional
  /// and may be null depending on Auth0's configuration.
  Auth0MultiFactorVerifyResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  /// Parses a JSON map into an [Auth0MultiFactorVerifyResponse] instance.
  ///
  /// The [json] parameter should contain the response from Auth0's MFA verification endpoint.
  /// Required fields:
  /// - 'access_token': The OAuth 2.0 access token
  /// - 'id_token': The OpenID Connect identity token
  ///
  /// Optional fields:
  /// - 'refresh_token': The refresh token (if offline_access scope was requested)
  /// - 'token_type': Typically "Bearer"
  /// - 'expires_in': Lifetime of the access token in seconds
  ///
  /// Throws:
  /// - [FormatException] if required fields are missing or invalid
  factory Auth0MultiFactorVerifyResponse.fromJson(Map<String, dynamic> json) {
    return Auth0MultiFactorVerifyResponse(
      accessToken: json['access_token'],
      idToken: json['id_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}
