/// Exception thrown when a signup operation fails during
/// the Auth0 authentication process.
///
/// This exception provides a simple error message to describe
/// what went wrong during user registration.
class Auth0SignupException implements Exception {
  /// A human-readable description of the signup error.
  final String message;

  /// Constructs an [Auth0SignupException] with the provided [message].
  Auth0SignupException(this.message);

  @override
  String toString() => 'Auth0SignupException: $message';
}
