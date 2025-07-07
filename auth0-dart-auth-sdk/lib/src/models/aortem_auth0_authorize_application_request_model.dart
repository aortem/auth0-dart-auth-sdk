/// A request model representing parameters required to initiate
/// an Auth0 authorization code flow or other OAuth 2.0 flows.
///
/// This is typically used to construct the URL for the `/authorize` endpoint.
class AortemAuth0AuthorizeApplicationRequest {
  /// The Auth0 client ID (application identifier).
  ///
  /// This is a required field and must be provided to identify the application.
  final String clientId;

  /// The URI to which Auth0 will redirect after authorization.
  ///
  /// This must be registered in your Auth0 application's allowed callback URLs.
  final Uri redirectUri;

  /// The type of response expected from the authorization server.
  ///
  /// Common values include `code` for authorization code flow,
  /// or `token` for implicit flow.
  final String responseType;

  /// The scopes requested during authorization (e.g. `openid profile email`).
  ///
  /// If not provided, defaults to basic scopes as configured in Auth0.
  final String? scope;

  /// An optional opaque value used by the client to maintain state
  /// between the request and callback.
  ///
  /// This is useful to prevent CSRF attacks.
  final String? state;

  /// Specifies the API identifier for which the token is intended (audience).
  ///
  /// This is typically used to request access tokens for APIs.
  final String? audience;

  /// Specifies the identity provider or connection to be used.
  ///
  /// For example: `google-oauth2`, `Username-Password-Authentication`.
  final String? connection;

  /// Controls the behavior of the authentication prompt.
  ///
  /// Examples: `none`, `login`, `consent`, etc.
  final String? prompt;

  /// Creates a new [AortemAuth0AuthorizeApplicationRequest].
  ///
  /// [clientId], [redirectUri], and [responseType] are required.
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
