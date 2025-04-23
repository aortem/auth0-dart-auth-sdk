/// Exception thrown when retrieving or processing the Auth0 user profile fails.
///
/// This exception is used to indicate issues such as failed user info requests,
/// unexpected data formats, or missing user attributes.
class AortemAuth0UserProfileException implements Exception {
  /// A human-readable description of the user profile error.
  final String message;

  /// Constructs an [AortemAuth0UserProfileException] with the provided [message].
  AortemAuth0UserProfileException(this.message);

  @override
  String toString() => 'AortemAuth0UserProfileException: $message';
}
