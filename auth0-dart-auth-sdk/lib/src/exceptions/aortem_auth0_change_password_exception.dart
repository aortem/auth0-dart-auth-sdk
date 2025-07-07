/// An exception thrown when a password change operation with Auth0 fails.
///
/// This exception is typically thrown by [AortemAuth0ChangePassword] when:
/// - The API request to Auth0 fails (non-200 status code)
/// - The response from Auth0 cannot be parsed
/// - Any other error occurs during the password change process
///
/// The [message] property contains details about what went wrong,
/// which may come from:
/// - Auth0's error response
/// - Network or HTTP errors
/// - JSON parsing errors
class AortemAuth0ChangePasswordException implements Exception {
  /// A human-readable message describing the error that occurred.
  ///
  /// This may contain:
  /// - Auth0's error description
  /// - HTTP status information
  /// - Parsing error details
  /// - Other relevant error information
  final String message;

  /// Creates an [AortemAuth0ChangePasswordException] with the given error message.
  ///
  /// [message]: The detailed error description (required).
  AortemAuth0ChangePasswordException(this.message);

  /// Returns a string representation of this exception.
  ///
  /// The string includes both the exception type and the error message
  /// for better debugging and error reporting.
  @override
  String toString() {
    return 'AortemAuth0ChangePasswordException: $message';
  }
}
