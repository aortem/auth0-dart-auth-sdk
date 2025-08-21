/// Represents the request payload for passive authentication via Auth0 using
/// database, Active Directory (AD), or LDAP connections.
///
/// This model encapsulates all parameters required for the Resource Owner Password
/// Grant flow (ROPC) when authenticating against Auth0's database, AD, or LDAP
/// connections. Passive authentication refers to non-interactive authentication
/// where credentials are provided directly rather than through a redirect flow.
///
/// Usage Example:
/// ```dart
/// final request = Auth0DatabaseAdLdapPassiveRequest(
///   username: 'user@example.com',
///   password: 'securePassword123',
///   connection: 'Username-Password-Authentication',
///   clientId: 'YOUR_AUTH0_CLIENT_ID',
///   scope: 'openid profile email',
///   audience: 'https://api.example.com'
/// );
/// ```
///
/// Security Note:
/// - The ROPC flow should only be used for trusted first-party clients
/// - Never use this flow in client-side applications where credentials could be exposed
class Auth0DatabaseAdLdapPassiveRequest {
  /// The user's unique identifier for authentication.
  ///
  /// This can be either:
  /// - A username (when using database/LDAP connections)
  /// - An email address (when using database connections with email enabled)
  /// - A user principal name (UPN) (when using AD connections)
  ///
  /// Must not be empty or contain only whitespace.
  final String username;

  /// The user's secret credential for authentication.
  ///
  /// The password will be transmitted securely to Auth0 for verification.
  /// The complexity requirements depend on the connection's password policy.
  ///
  /// Must not be empty or contain only whitespace.
  final String password;

  /// The name of the Auth0 connection to use for authentication.
  ///
  /// This identifies the identity provider configuration in Auth0.
  /// Common values:
  /// - 'Username-Password-Authentication' (for database connections)
  /// - 'contoso-ad-connection' (for custom AD/LDAP connections)
  ///
  /// Must not be empty or contain only whitespace.
  final String connection;

  /// The client ID of the Auth0 application initiating the authentication.
  ///
  /// Optional but recommended for:
  /// - Proper audit logging
  /// - Application-specific rules enforcement
  /// - Token customization
  ///
  /// If omitted, the Auth0 tenant's default client may be used.
  final String? clientId;

  /// The OAuth 2.0 scope defining the requested permissions/claims.
  ///
  /// Common space-separated values:
  /// - 'openid': Required for OIDC flows
  /// - 'profile': Requests basic profile claims
  /// - 'email': Requests email-related claims
  /// - 'offline_access': Requests refresh token
  ///
  /// Defaults to 'openid' if not specified in Auth0.
  final String? scope;

  /// The audience for the requested access token.
  ///
  /// This should match the identifier of the API you want to call with the token.
  /// Required when requesting tokens for specific APIs.
  ///
  /// Example: 'https://api.example.com'
  final String? audience;

  /// Creates an authentication request instance.
  ///
  /// Parameters:
  /// - [username]: Required user identifier
  /// - [password]: Required user credential
  /// - [connection]: Required Auth0 connection name
  /// - [clientId]: Optional application client ID
  /// - [scope]: Optional requested permissions
  /// - [audience]: Optional target API identifier
  ///
  /// Throws:
  /// - [ArgumentError] if required fields are empty or whitespace-only
  Auth0DatabaseAdLdapPassiveRequest({
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

  /// Serializes this request to a JSON map suitable for Auth0's API.
  ///
  /// Returns:
  /// A [Map<String, dynamic>] with all non-null properties included.
  /// The structure matches Auth0's /oauth/token endpoint expectations.
  ///
  /// Example Output:
  /// ```json
  /// {
  ///   "username": "user@example.com",
  ///   "password": "securePassword123",
  ///   "connection": "Username-Password-Authentication",
  ///   "client_id": "YOUR_CLIENT_ID",
  ///   "scope": "openid profile",
  ///   "audience": "https://api.example.com"
  /// }
  /// ```
  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'connection': connection,
    if (clientId != null) 'client_id': clientId,
    if (scope != null) 'scope': scope,
    if (audience != null) 'audience': audience,
  };
}
