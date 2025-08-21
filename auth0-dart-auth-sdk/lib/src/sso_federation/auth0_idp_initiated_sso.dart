/// Model for the request to build an IdP Initiated SSO Flow URL.
///
/// Contains all the necessary parameters to construct an Identity Provider (IdP)
/// initiated Single Sign-On (SSO) flow URL for Auth0 authentication.
class Auth0IdpInitiatedSSOFlowRequest {
  /// The client ID of the application initiating the SSO flow.
  /// This is a required field and cannot be empty.
  final String clientId;

  /// The URI to redirect to after authentication is complete.
  /// This is optional but recommended for proper flow completion.
  final String? redirectUri;

  /// The specific connection to use for authentication (e.g., "google-oauth2").
  /// This is optional - Auth0 will use its default connection if not specified.
  final String? connection;

  /// The protocol to use for the authentication flow.
  /// This is optional - typically used for special protocol requirements.
  final String? protocol;

  /// Creates a request for IdP Initiated SSO Flow URL construction.
  ///
  /// [clientId] is required and must not be empty or whitespace-only.
  /// [redirectUri], [connection], and [protocol] are optional parameters.
  ///
  /// Throws [ArgumentError] if [clientId] is empty.
  Auth0IdpInitiatedSSOFlowRequest({
    required this.clientId,
    this.redirectUri,
    this.connection,
    this.protocol,
  }) {
    if (clientId.trim().isEmpty) {
      throw ArgumentError('clientId is required and cannot be empty.');
    }
  }
}

/// Model for the response containing the constructed SSO URL.
///
/// Wraps the fully constructed Uri that the application can use to
/// redirect the user to begin the SSO process.
class Auth0IdpInitiatedSSOFlowResponse {
  /// The fully constructed URL for initiating the IdP SSO flow.
  final Uri ssoUrl;

  /// Creates a response with the constructed SSO URL.
  ///
  /// [ssoUrl] should be a fully formed Uri ready for redirection.
  Auth0IdpInitiatedSSOFlowResponse(this.ssoUrl);
}

/// Constructs a URL for an Identity Provider (IdP) initiated Single Sign-On (SSO) flow.
///
/// This function builds the appropriate URL that applications can use to redirect users
/// to begin the SSO authentication process with Auth0. Note that this does not perform
/// an actual HTTP request - it only constructs the URL for the flow initiation.
///
/// Example:
/// ```dart
/// final request = Auth0IdpInitiatedSSOFlowRequest(
///   clientId: 'your_client_id',
///   redirectUri: 'https://your.app/callback',
/// );
/// final response = Auth0IdpInitiatedSSOFlow(
///   auth0DomainUri: Uri.parse('https://your-domain.auth0.com'),
///   request: request,
/// );
/// // Redirect user to response.ssoUrl
/// ```
///
/// [auth0DomainUri] is the base URI of your Auth0 domain (e.g., 'https://your-domain.auth0.com').
/// [request] contains all the parameters needed to construct the SSO URL.
///
/// Returns [Auth0IdpInitiatedSSOFlowResponse] containing the constructed URL.
///
/// Throws [Exception] if URL construction fails for any reason.
Auth0IdpInitiatedSSOFlowResponse Auth0IdpInitiatedSSOFlow({
  required Uri auth0DomainUri,
  required Auth0IdpInitiatedSSOFlowRequest request,
}) {
  try {
    final queryParameters = {
      'client': request.clientId,
      if (request.redirectUri != null) 'redirect_uri': request.redirectUri!,
      if (request.connection != null) 'connection': request.connection!,
      if (request.protocol != null) 'protocol': request.protocol!,
    };

    final uri = Uri(
      scheme: auth0DomainUri.scheme,
      host: auth0DomainUri.host,
      path: '/login',
      queryParameters: queryParameters,
    );

    return Auth0IdpInitiatedSSOFlowResponse(uri);
  } catch (e) {
    throw Exception('Failed to construct IdP Initiated SSO URL: $e');
  }
}
