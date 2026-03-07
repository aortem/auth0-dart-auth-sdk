/// A response model containing the full authorization URL used to initiate
/// an OAuth 2.0 or OpenID Connect flow with Auth0.
class Auth0AuthorizeApplicationResponse {
  /// The fully constructed authorization URL.
  ///
  /// This URL includes all necessary query parameters such as:
  /// - `client_id`
  /// - `redirect_uri`
  /// - `response_type`
  /// - `scope`, `state`, `audience`, etc. (if provided)
  ///
  /// It should be used to redirect the user's browser to begin authentication.
  final Uri url;

  /// Creates an [Auth0AuthorizeApplicationResponse] containing the
  /// [url] to redirect the user to the Auth0 `/authorize` endpoint.
  Auth0AuthorizeApplicationResponse({required this.url});
}
