/// A request model containing parameters needed to generate an Auth0 authorization URL.
class AortemAuth0AuthorizeApplicationRequest {
  /// The Auth0 client ID.
  final String clientId;

  /// The URI to redirect to after login.
  final Uri redirectUri;

  /// The expected OAuth2 response type (e.g., "code").
  final String responseType;

  /// The scope of access requested (e.g., "openid profile email").
  final String? scope;

  /// A randomly generated value to maintain state between the request and the callback.
  final String? state;

  /// The audience for the access token.
  final String? audience;

  /// The specific connection to use (e.g., "google-oauth2").
  final String? connection;

  /// The prompt behavior (e.g., "login", "none").
  final String? prompt;

  /// Constructs an [AortemAuth0AuthorizeApplicationRequest].
  AortemAuth0AuthorizeApplicationRequest({
    required this.clientId,
    required this.redirectUri,
    required this.responseType,
    this.scope,
    this.state,
    this.audience,
    this.connection,
    this.prompt,
  });
}
