/// Represents the response from a request to globally revoke a token with Auth0.
///
/// This response indicates whether the token revocation operation was successful.
class Auth0GlobalTokenRevocationResponse {
  /// Indicates whether the token revocation was successful.
  final bool success;

  /// Constructs an [Auth0GlobalTokenRevocationResponse] with the given [success] status.
  Auth0GlobalTokenRevocationResponse({required this.success});
}
