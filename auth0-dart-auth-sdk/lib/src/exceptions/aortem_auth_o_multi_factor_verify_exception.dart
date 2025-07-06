/// An exception thrown when multi-factor authentication (MFA) verification fails.
///
/// This exception captures details about MFA verification failures when
/// interacting with Auth0's MFA endpoints, including:
/// - Error messages from Auth0
/// - HTTP status codes
/// - Additional error details (when available)
///
/// Common scenarios that trigger this exception:
/// - Invalid or expired verification codes
/// - Exceeded MFA attempt limits
/// - MFA enrollment requirements not met
/// - Timeout during verification
///
/// Example Usage:
/// ```dart
/// try {
///   await mfaService.verify(request);
/// } on AortemAuth0MultifactorVerifyException catch (e) {
///   logger.error('MFA failed: ${e.message}');
///   showErrorToUser(e.message);
/// }
/// ```
class AortemAuth0MultifactorVerifyException implements Exception {
  /// A human-readable error message describing the verification failure.
  ///
  /// Typically contains Auth0's error description that can be safely
  /// displayed to end-users. Example:
  /// "Invalid verification code" or "MFA verification timeout"
  final String message;

  /// The HTTP status code returned by the Auth0 API.
  ///
  /// Common status codes:
  /// - 400: Bad request (invalid parameters)
  /// - 401: Unauthorized (invalid credentials)
  /// - 403: Forbidden (MFA required but not provided)
  /// - 429: Too many requests (rate limited)
  final int statusCode;

  /// Additional error details from Auth0's response.
  ///
  /// Contains structured error information that may be useful for debugging.
  /// Typically includes:
  /// - error: The error type (e.g., "invalid_grant")
  /// - error_description: Detailed error explanation
  /// - mfa_token: The MFA token (if available)
  /// - recovery_codes: Available recovery options (if applicable)
  final Map<String, dynamic>? details;

  /// Creates an MFA verification exception instance.
  ///
  /// Parameters:
  /// - [message]: Required error description
  /// - [statusCode]: Required HTTP status code
  /// - [details]: Optional additional error context
  ///
  /// Throws:
  /// - [ArgumentError] if message is empty or statusCode is invalid
  AortemAuth0MultifactorVerifyException({
    required this.message,
    required this.statusCode,
    this.details,
  }) {
    if (message.trim().isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }
    if (statusCode < 400 || statusCode > 599) {
      throw ArgumentError('Status code must be an HTTP error code (4xx-5xx)');
    }
  }

  /// Returns a string representation of this exception.
  ///
  /// Format: "AortemAuth0Exception(statusCode): message"
  /// Example: "AortemAuth0Exception(400): Invalid verification code"
  @override
  String toString() => 'AortemAuth0Exception($statusCode): $message';
}
