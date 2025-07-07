/// Represents a request to fetch user information from Auth0's /userinfo endpoint.
///
/// This class encapsulates the required authentication token needed to
/// make an authorized request to Auth0's OpenID Connect user information endpoint.
/// The endpoint returns claims about the authenticated user.
///
/// Example usage:
/// ```dart
/// final request = AortemAuth0GetUserInfoRequest(accessToken: 'your_auth0_token');
/// final response = await auth0Client.getUserInfo(request);
/// ```
///
/// Throws:
/// - [ArgumentError] if the provided access token is empty or whitespace only.
class AortemAuth0GetUserInfoRequest {
  /// The OAuth 2.0 access token used to authenticate the user info request.
  ///
  /// This token should have been previously obtained during the authentication flow
  /// and must have the `openid` scope (at minimum) to access the userinfo endpoint.
  /// The token must be non-empty and valid.
  final String accessToken;

  /// Creates a request for user information from Auth0.
  ///
  /// [accessToken] is required and must be a non-empty string representing a valid
  /// OAuth 2.0 access token obtained through Auth0's authentication flow.
  ///
  /// Throws:
  /// - [ArgumentError] if [accessToken] is empty or contains only whitespace.
  AortemAuth0GetUserInfoRequest({required this.accessToken}) {
    if (accessToken.trim().isEmpty) {
      throw ArgumentError('Access token must not be empty.');
    }
  }
}
