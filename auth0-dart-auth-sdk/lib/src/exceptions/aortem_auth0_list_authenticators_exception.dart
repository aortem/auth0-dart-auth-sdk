/// An exception thrown when an error occurs while listing MFA (Multi-Factor Authentication)
/// authenticators from Auth0.
///
/// This exception captures error details that occur during the process of retrieving
/// a user's registered authenticators, providing specific failure information
/// for error handling and debugging purposes.
///
/// Example usage:
/// ```dart
/// try {
///   // Attempt to list authenticators
/// } on AortemAuth0ListAuthenticatorsException catch (e) {
///   print('Failed to list authenticators: ${e.message}');
///   // Handle specific error case
/// }
/// ```
class AortemAuth0ListAuthenticatorsException implements Exception {
  /// A human-readable error message describing the failure.
  ///
  /// Typically contains details about what went wrong during the authenticator
  /// listing operation, such as:
  /// - Authentication failures
  /// - Permission issues
  /// - API communication errors
  /// - Data parsing failures
  final String message;

  /// Creates a new [AortemAuth0ListAuthenticatorsException] instance.
  ///
  /// [message] should provide specific details about the error condition.
  /// Must be a non-empty string describing the failure.
  AortemAuth0ListAuthenticatorsException(this.message) {
    if (message.isEmpty) {
      throw ArgumentError('Exception message cannot be empty');
    }
  }

  @override
  String toString() => 'AortemAuth0ListAuthenticatorsException: $message';
}
