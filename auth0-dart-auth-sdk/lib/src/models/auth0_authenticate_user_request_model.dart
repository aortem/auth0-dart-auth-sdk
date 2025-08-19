/// Represents the request payload for authenticating a user via Auth0's
/// Resource Owner Password Grant (password-based authentication).
class Auth0AuthenticateUserRequest {
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
  final bool usePasswordRealm;

  /// Constructs a request to authenticate a user using username/password.
  Auth0AuthenticateUserRequest({
    required this.username,
    required this.password,
    required this.connection,
    required this.clientId,
    this.clientSecret,
    this.scope,
    this.audience,
    this.usePasswordRealm = false,
  }) {
    if (username.trim().isEmpty ||
        password.trim().isEmpty ||
        connection.trim().isEmpty ||
        clientId.trim().isEmpty) {
      throw ArgumentError(
        'Username, password, connection/realm, and clientId must not be empty.',
      );
    }
  }

  /// Converts the request to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    final data = {
      'grant_type': usePasswordRealm
          ? 'http://auth0.com/oauth/grant-type/password-realm'
          : 'password',
      'username': username,
      'password': password,
      if (usePasswordRealm) 'realm': connection else 'connection': connection,
      'client_id': clientId,
    };

    if (clientSecret != null && clientSecret!.trim().isNotEmpty) {
      data['client_secret'] = clientSecret!;
    }
    if (scope != null && scope!.trim().isNotEmpty) {
      data['scope'] = scope!;
    }
    if (audience != null && audience!.trim().isNotEmpty) {
      data['audience'] = audience!;
    }
    return data;
  }
}
