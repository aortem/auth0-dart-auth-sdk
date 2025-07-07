/// An exception thrown when a user info request to Auth0 fails.
///
/// This exception captures error details that occur when attempting to retrieve
/// user information from Auth0's `/userinfo` endpoint, including both
/// network/HTTP errors and Auth0-specific errors.
///
/// Example usage:
/// ```dart
/// try {
///   final userInfo = await auth0Client.getUserInfo();
/// } on AortemAuth0UserInfoException catch (e) {
///   print('Failed to get user info: ${e.message}');
///   if (e.statusCode != null) {
///     print('HTTP status code: ${e.statusCode}');
///   }
/// }
/// ```
///
/// The exception includes:
/// - A descriptive error message
/// - The HTTP status code (if available)
class AortemAuth0UserInfoException implements Exception {
  /// A human-readable error message describing the failure.
  ///
  /// This may contain Auth0-specific error information or details about
  /// network/transport failures.
  final String message;

  /// The HTTP status code returned by the failed request, if available.
  ///
  /// Common status codes include:
  /// - 401: Invalid or expired access token
  /// - 403: Insufficient permissions
  /// - 404: User not found
  /// - 500: Auth0 server error
  /// Null if the failure occurred before reaching the server (e.g., network error).
  final int? statusCode;

  /// Creates a user info exception with an error message and optional status code.
  ///
  /// [message] should describe the error condition and is required.
  /// [statusCode] should be included when the error comes from an HTTP response.
  AortemAuth0UserInfoException(this.message, [this.statusCode]);

  @override
  String toString() => 'AortemAuth0UserInfoException($statusCode): $message';
}
