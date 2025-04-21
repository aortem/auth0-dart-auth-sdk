/// Exception thrown when a signup operation fails during
/// the Auth0 authentication process.
///
/// This exception provides a simple error message to describe
/// what went wrong during user registration.
class AortemAuth0SignupException implements Exception {
  /// A human-readable description of the signup error.
  final String message;

  /// Constructs an [AortemAuth0SignupException] with the provided [message].
  AortemAuth0SignupException(this.message);

  @override
  String toString() => 'AortemAuth0SignupException: $message';
}
