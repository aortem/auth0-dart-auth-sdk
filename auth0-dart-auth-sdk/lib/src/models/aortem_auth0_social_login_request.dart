/// Represents the request payload for social authentication via Auth0.
class AortemAuth0SocialLoginRequest {
  /// The access token provided by the social provider.
  final String socialAccessToken;

  /// The Auth0 connection name (e.g., "facebook", "google-oauth2").
  final String connection;

  /// Optional: The client ID for the Auth0 application.
  final String? clientId;

  /// Optional: The scope of the requested tokens.
  final String? scope;

  /// Optional: The audience for the token.
  final String? audience;

  ///constructure
  AortemAuth0SocialLoginRequest({
    required this.socialAccessToken,
    required this.connection,
    this.clientId,
    this.scope,
    this.audience,
  }) {
    if (socialAccessToken.trim().isEmpty || connection.trim().isEmpty) {
      throw ArgumentError(
          'Social access token and connection cannot be empty.');
    }
  }

  /// Converts this request into a JSON map.
  Map<String, dynamic> toJson() => {
        'access_token': socialAccessToken,
        'connection': connection,
        if (clientId != null) 'client_id': clientId,
        if (scope != null) 'scope': scope,
        if (audience != null) 'audience': audience,
      };
}
