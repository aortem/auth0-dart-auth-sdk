/// An exception thrown when an error occurs during the deletion of an MFA (Multi-Factor Authentication)
/// authenticator in Auth0.
///
/// This exception provides detailed error information when a request to remove
/// an authenticator fails, including API errors, permission issues, or invalid requests.
/// It should be caught and handled appropriately in the calling code.
///
/// Example Usage:
/// ```dart
/// try {
///   await auth0Client.deleteAuthenticator(request);
/// } on Auth0DeleteAuthenticatorException catch (e) {
///   logger.error('Failed to delete authenticator: ${e.message}');
///   showErrorToUser(e.message);
/// }
/// ```
class Auth0DeleteAuthenticatorException implements Exception {
  /// A detailed error message explaining why the authenticator deletion failed.
  ///
  /// Contains specific failure information that may include:
  /// - Authentication or authorization errors
  /// - Invalid authenticator ID
  /// - API communication failures
  /// - Server-side validation errors
  /// - Permission restrictions
  final String message;

  /// Creates a new [Auth0DeleteAuthenticatorException] instance.
  ///
  /// [message] must be a non-empty string containing specific error details
  /// about the deletion failure. This message will be available for error
  /// reporting and user feedback.
  ///
  /// Throws:
  /// - [ArgumentError] if the message is empty or null
  Auth0DeleteAuthenticatorException(this.message) {
    if (message.isEmpty) {
      throw ArgumentError('Exception message cannot be empty');
    }
  }

  /// Returns a formatted string representation of the exception.
  ///
  /// The output follows the format:
  /// `Auth0DeleteAuthenticatorException: [message]`
  @override
  String toString() {
    return 'Auth0DeleteAuthenticatorException: $message';
  }
}
