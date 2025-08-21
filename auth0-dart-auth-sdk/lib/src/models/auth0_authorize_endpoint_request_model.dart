/// Represents a request to Auth0's OAuth 2.0/OpenID Connect authorization endpoint.
///
/// This class encapsulates all parameters needed to construct a proper authorization request
/// according to OAuth 2.0 and OpenID Connect specifications. It generates the query parameters
/// used in the authorization URL that initiates the authentication flow.
///
/// Example usage:
/// ```dart
/// final request = Auth0AuthorizeEndpointRequest(
///   clientId: 'YOUR_CLIENT_ID',
///   redirectUri: Uri.parse('https://yourapp.com/callback'),
///   responseType: 'code',
///   scope: 'openid profile email',
///   state: 'random_state_value',
///   nonce: 'random_nonce_value',
///   prompt: 'login',
///   connection: 'google-oauth2',
/// );
///
/// final params = request.toQueryParameters();
/// final authUrl = Uri.https('yourdomain.auth0.com', '/authorize', params);
/// ```
class Auth0AuthorizeEndpointRequest {
  /// The client identifier for your Auth0 application.
  ///
  /// This must match exactly the client ID configured in your Auth0 dashboard.
  final String clientId;

  /// The URI to which Auth0 will redirect after authentication.
  ///
  /// This must be pre-registered in your Auth0 application settings and must use HTTPS
  /// for production applications (except for localhost).
  final Uri redirectUri;

  /// The OAuth 2.0 response type value.
  ///
  /// Common values:
  /// - 'code' for authorization code flow
  /// - 'token' for implicit flow
  /// - 'id_token token' for OpenID Connect hybrid flow
  final String responseType;

  /// The scope of access being requested.
  ///
  /// For OpenID Connect, must include 'openid'. Multiple scopes are space-separated.
  /// Example: 'openid profile email offline_access'
  final String scope;

  /// An opaque value used to maintain state between the request and callback.
  ///
  /// This is used for CSRF protection and will be returned unchanged in the response.
  /// Should be a cryptographically random value.
  final String state;

  /// A string value used to associate a client session with an ID token.
  ///
  /// This is mandatory for OpenID Connect flows to mitigate replay attacks.
  /// Should be a cryptographically random value.
  final String nonce;

  /// Optional space-delimited, case-sensitive list of prompts to present to the user.
  ///
  /// Possible values:
  /// - 'none': No authentication or consent pages displayed
  /// - 'login': Force re-authentication
  /// - 'consent': Force consent screen
  /// - 'select_account': Show account selection
  final String? prompt;

  /// Optional maximum allowable elapsed time since last authentication (in seconds).
  ///
  /// If the elapsed time is greater than this value, re-authentication will be required.
  final int? maxAge;

  /// Optional Auth0 connection to use for authentication.
  ///
  /// Specifies which identity provider or database connection to use.
  /// Example: 'google-oauth2', 'Username-Password-Authentication'
  final String? connection;

  /// Optional additional parameters to include in the authorization request.
  ///
  /// These will be added as-is to the query parameters. Use for custom or
  /// provider-specific parameters not covered by the main properties.
  final Map<String, String>? additionalParams;

  /// Creates an authorization endpoint request.
  ///
  /// Required parameters:
  /// - [clientId]: Your Auth0 application's client ID
  /// - [redirectUri]: Registered callback URI
  /// - [responseType]: OAuth 2.0 response type
  /// - [scope]: Requested scopes (must include 'openid' for OIDC)
  /// - [state]: CSRF protection value
  /// - [nonce]: Replay attack protection value
  ///
  /// Optional parameters:
  /// - [prompt]: Authentication prompt behavior
  /// - [maxAge]: Maximum authentication age
  /// - [connection]: Specific connection to use
  /// - [additionalParams]: Additional custom parameters
  Auth0AuthorizeEndpointRequest({
    required this.clientId,
    required this.redirectUri,
    required this.responseType,
    required this.scope,
    required this.state,
    required this.nonce,
    this.prompt,
    this.maxAge,
    this.connection,
    this.additionalParams,
  });

  /// Converts the request to query parameters for the authorization URL.
  ///
  /// Returns a map of parameter names to values, properly formatted for inclusion
  /// in the authorization endpoint URL. Includes all required OAuth 2.0/OIDC parameters
  /// plus any optional parameters that were specified.
  ///
  /// Example output:
  /// ```json
  /// {
  ///   "client_id": "YOUR_CLIENT_ID",
  ///   "redirect_uri": "https://yourapp.com/callback",
  ///   "response_type": "code",
  ///   "scope": "openid profile",
  ///   "state": "abc123",
  ///   "nonce": "xyz456",
  ///   "prompt": "login"
  /// }
  /// ```
  Map<String, String> toQueryParameters() {
    final params = <String, String>{
      'client_id': clientId,
      'redirect_uri': redirectUri.toString(),
      'response_type': responseType,
      'scope': scope,
      'state': state,
      'nonce': nonce,
    };

    if (prompt != null) params['prompt'] = prompt!;
    if (maxAge != null) params['max_age'] = maxAge!.toString();
    if (connection != null) params['connection'] = connection!;
    if (additionalParams != null) params.addAll(additionalParams!);

    return params;
  }
}
