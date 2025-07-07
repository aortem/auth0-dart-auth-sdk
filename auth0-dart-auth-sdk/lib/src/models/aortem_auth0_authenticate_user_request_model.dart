/// Represents the request payload for authenticating a user via Auth0's
/// Resource Owner Password Grant (password-based authentication).
class AortemAuth0AuthenticateUserRequest {
  /// The user's username or email.
  final String username;

  /// The user's password.
  final String password;

  /// The Auth0 connection name (e.g., 'Username-Password-Authentication').
  final String connection;

  /// The client ID of your Auth0 application.
  final String clientId;

  /// Optional client secret for confidential applications.
  final String? clientSecret;

  /// Optional scope (e.g., 'openid profile email').
  final String? scope;

  /// Optional audience, used to target a specific API identifier.
  final String? audience;

  /// Constructs a request to authenticate a user using username/password.
  AortemAuth0AuthenticateUserRequest({
    required this.username,
    required this.password,
    required this.connection,
    required this.clientId,
    this.clientSecret,
    this.scope,
    this.audience,
  });

  /// Converts the request to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'grant_type': 'password',
      'username': username,
      'password': password,
      'connection': connection,
      'client_id': clientId,
      if (clientSecret != null) 'client_secret': clientSecret,
      if (scope != null) 'scope': scope,
      if (audience != null) 'audience': audience,
    };
  }
}
