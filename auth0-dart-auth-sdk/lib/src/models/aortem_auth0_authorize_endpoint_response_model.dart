/// Represents the response containing the constructed authorization URL for Auth0's OAuth 2.0/OpenID Connect flow.
///
/// This class encapsulates the fully-formed authorization URL that should be used to
/// initiate the authentication flow. The URL contains all necessary query parameters
/// as specified in the original [AortemAuth0AuthorizeEndpointRequest].
///
/// Example usage:
/// ```dart
/// final response = AortemAuth0AuthorizeEndpointResponse(authorizationUrl);
/// // Redirect user to response.authorizationUrl
/// launchUrl(response.authorizationUrl);  // Using url_launcher package
/// ```
///
/// Security considerations:
/// - The authorization URL contains sensitive parameters and should be handled securely
/// - Always validate the domain matches your expected Auth0 domain before redirecting
class AortemAuth0AuthorizeEndpointResponse {
  /// The complete authorizati c on URL with all required OAuth 2.0/OpenID Connect parameters.
  ///
  /// This URL should be used to initiate the authentication flow, typically by
  /// redirecting the user's browser to this address. The URL includes:
  /// - Auth0 domain
  /// - Client ID
  /// - Response type
  /// - Scopes
  /// - State and nonce parameters
  /// - Any additional parameters from the original request
  final Uri authorizationUrl;

  /// Creates an authorization endpoint response.
  ///
  /// [authorizationUrl] must be a valid, non-null Uri containing the complete
  /// authorization endpoint URL with all required query parameters.
  AortemAuth0AuthorizeEndpointResponse(this.authorizationUrl);

  /// Alias for [authorizationUrl].
  Uri get url => authorizationUrl;
}
