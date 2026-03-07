/// Represents the response from accepting a passwordless authentication request.
///
/// Contains the tokens returned by Auth0 after successfully accepting the
/// passwordless login request.
class Auth0AcceptRequestResponse {
  /// The access token used to authenticate API requests.
  final String accessToken;

  /// The ID token containing user profile information.
  final String idToken;

  /// The refresh token that can be used to obtain new access tokens.
  ///
  /// May be null if the authentication flow doesn't support refresh tokens.
  final String? refreshToken;

  /// The type of token returned (typically "Bearer").
  final String? tokenType;

  /// The number of seconds until the access token expires.
  final int? expiresIn;

  /// Creates a new [Auth0AcceptRequestResponse] instance.
  Auth0AcceptRequestResponse({
    required this.accessToken,
    required this.idToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  /// Creates an [Auth0AcceptRequestResponse] from a JSON map.
  ///
  /// Throws an exception if the required fields are not present.
  factory Auth0AcceptRequestResponse.fromJson(Map<String, dynamic> json) {
    return Auth0AcceptRequestResponse(
      accessToken: json['access_token'],
      idToken: json['id_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}
