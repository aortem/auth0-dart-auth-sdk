/// Represents a request to list a user's MFA (Multi-Factor Authentication) authenticators
/// from Auth0.
///
/// This request model contains the authentication token required to fetch
/// the list of registered authenticators for the current user.
///
/// Example usage:
/// ```dart
/// final request = AortemAuth0ListAuthenticatorsRequest(accessToken);
/// ```
class AortemAuth0ListAuthenticatorsRequest {
  /// The OAuth 2.0 access token used to authenticate the request.
  ///
  /// Must be a valid JWT token with the following scopes/permissions:
  /// - `read:authenticators` (to view registered authenticators)
  /// - `read:mfa` (for MFA configuration access)
  ///
  /// The token should be obtained through standard Auth0 authentication flows.
  final String accessToken;

  /// Creates a new [AortemAuth0ListAuthenticatorsRequest] instance.
  ///
  /// [accessToken] must be a non-empty string containing a valid Auth0 access token
  /// with the required permissions to list MFA authenticators.
  ///
  /// Throws:
  /// - [ArgumentError] if the access token is empty or null
  AortemAuth0ListAuthenticatorsRequest(this.accessToken) {
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token cannot be empty');
    }
  }
}
