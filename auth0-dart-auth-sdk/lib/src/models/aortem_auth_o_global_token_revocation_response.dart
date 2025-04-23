/// Represents the response from a request to globally revoke a token with Auth0.
///
/// This response indicates whether the token revocation operation was successful.
class AortemAuth0GlobalTokenRevocationResponse {
  /// Indicates whether the token revocation was successful.
  final bool success;

  /// Constructs an [AortemAuth0GlobalTokenRevocationResponse] with the given [success] status.
  AortemAuth0GlobalTokenRevocationResponse({required this.success});
}
