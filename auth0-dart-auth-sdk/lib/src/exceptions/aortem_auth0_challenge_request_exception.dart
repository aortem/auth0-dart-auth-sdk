/// An exception thrown when an Auth0 challenge fails during authentication.
///
/// This exception is typically thrown when there's an issue during the
/// authentication process with Auth0 that requires a challenge (such as MFA).
/// It includes an error message and optionally an HTTP status code if the
/// failure came from an HTTP request.
///
/// Example:
/// ```dart
/// throw AortemAuth0ChallengeException('MFA verification failed', statusCode: 401);
/// ```
class AortemAuth0ChallengeException implements Exception {
  /// A message describing the authentication challenge failure.
  final String message;

  /// The HTTP status code associated with the failure, if applicable.
  final int? statusCode;

  /// Creates an [AortemAuth0ChallengeException] with the given [message]
  /// and optional [statusCode].
  AortemAuth0ChallengeException(this.message, {this.statusCode});

  @override
  String toString() =>
      'AortemAuth0ChallengeException: $message${statusCode != null ? ' (HTTP $statusCode)' : ''}';
}
