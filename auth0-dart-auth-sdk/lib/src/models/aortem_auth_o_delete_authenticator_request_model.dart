/// Represents a request to delete a Multi-Factor Authentication (MFA) authenticator
/// from an Auth0 user account.
///
/// This request contains the authentication token and identifier needed to remove
/// a specific authenticator device or method from a user's MFA configuration.
///
/// Typical usage:
/// ```dart
/// final request = AortemAuth0DeleteAuthenticatorRequest(
///   accessToken: 'valid_jwt_token',
///   authenticatorId: 'auth_123456'
/// );
/// ```
class AortemAuth0DeleteAuthenticatorRequest {
  /// The OAuth 2.0 access token used to authenticate the deletion request.
  ///
  /// Must be a valid JWT token with the following permissions:
  /// - `delete:authenticators` (to remove authenticators)
  /// - `delete:mfa` (for MFA configuration modifications)
  ///
  /// The token should be obtained through standard Auth0 authentication flows
  /// and must be current (not expired).
  final String accessToken;

  /// The unique identifier of the authenticator to be deleted.
  ///
  /// This ID should match an existing authenticator ID from the user's MFA
  /// configuration. Typically obtained from a prior list authenticators request.
  final String authenticatorId;

  /// Creates a new deletion request for an MFA authenticator.
  ///
  /// Both parameters are required and must be non-empty strings:
  /// - [accessToken]: Valid Auth0 access token with delete permissions
  /// - [authenticatorId]: ID of authenticator to remove
  ///
  /// Throws:
  /// - [ArgumentError] if either parameter is empty
  AortemAuth0DeleteAuthenticatorRequest({
    required this.accessToken,
    required this.authenticatorId,
  }) {
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token cannot be empty');
    }
    if (authenticatorId.isEmpty) {
      throw ArgumentError('Authenticator ID cannot be empty');
    }
  }
}
