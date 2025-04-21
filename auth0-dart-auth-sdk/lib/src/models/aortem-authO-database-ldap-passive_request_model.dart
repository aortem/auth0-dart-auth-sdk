/// Represents the request payload for passive authentication via Auth0 using Database/AD/LDAP.
class AortemAuth0DatabaseAdLdapPassiveRequest {
  /// The user's username or email
  final String username;

  /// The user's password
  final String password;

  /// The Auth0 connection name (e.g., "Username-Password-Authentication")
  final String connection;

  /// Optional: The client ID for the Auth0 application
  final String? clientId;

  /// Optional: The scope of the requested tokens
  final String? scope;

  /// Optional: The audience for the token
  final String? audience;

  AortemAuth0DatabaseAdLdapPassiveRequest({
    required this.username,
    required this.password,
    required this.connection,
    this.clientId,
    this.scope,
    this.audience,
  }) {
    if (username.trim().isEmpty ||
        password.trim().isEmpty ||
        connection.trim().isEmpty) {
      throw ArgumentError('Username, password and connection cannot be empty');
    }
  }

  /// Converts this request into a JSON map
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'connection': connection,
        if (clientId != null) 'client_id': clientId,
        if (scope != null) 'scope': scope,
        if (audience != null) 'audience': audience,
      };
}
