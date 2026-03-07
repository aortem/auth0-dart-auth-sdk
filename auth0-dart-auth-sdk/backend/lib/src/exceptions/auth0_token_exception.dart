/// An exception thrown when an error occurs during Auth0 token requests.
///
/// This exception is thrown when there's a failure in the token request process,
/// such as invalid credentials, expired tokens, or server errors. It captures both
/// the error message and the HTTP status code (when available) from the Auth0 response.
///
/// Example usage:
/// ```dart
/// try {
///   final token = await auth0Client.getToken(request);
/// } on Auth0TokenException catch (e) {
///   print('Token request failed: ${e.message}');
///   if (e.statusCode == 401) {
///     // Handle unauthorized cases
///   }
/// }
/// ```
///
/// Common status codes:
/// - 400: Bad request (invalid parameters)
/// - 401: Unauthorized (invalid credentials)
/// - 403: Forbidden (insufficient permissions)
/// - 429: Too many requests (rate limited)
class Auth0TokenException implements Exception {
  /// A human-readable error message describing what went wrong.
  ///
  /// This typically comes from Auth0's error response and may include details
  /// about invalid parameters, expired tokens, or other authentication issues.
  final String message;

  /// The HTTP status code returned by Auth0, if available.
  ///
  /// This can be used to determine the type of error that occurred and how to handle it.
  /// Common values include 400, 401, 403, and 429.
  final int? statusCode;

  /// Creates a new token exception instance.
  ///
  /// [message] is required and should describe the error condition.
  /// [statusCode] is optional but recommended when available from the HTTP response.
  Auth0TokenException(this.message, [this.statusCode]);

  @override
  String toString() => 'Auth0TokenException ($statusCode): $message';
}
