/// Exception thrown when social login fails during the
/// Auth0 authentication process.
///
/// This exception is typically used to represent errors occurring
/// while attempting to log in through a social identity provider
/// (e.g., Google, Facebook, Apple).
///
/// It provides a descriptive message, an optional HTTP status code,
/// and optional error details for further context.
class Auth0SocialLoginException implements Exception {
  /// A human-readable message describing the error.
  final String message;

  /// Optional HTTP status code returned by the Auth0 API or social provider.
  final int? statusCode;

  /// Optional additional error information such as a response body
  /// or structured error payload.
  final dynamic errorDetails;

  /// Constructs an [Auth0SocialLoginException] with the given [message],
  /// and optionally a [statusCode] and [errorDetails] for debugging purposes.
  Auth0SocialLoginException({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });

  @override
  String toString() =>
      'Auth0SocialLoginException: $message'
      '${statusCode != null ? ' (Status: $statusCode)' : ''}'
      '${errorDetails != null ? '\nDetails: $errorDetails' : ''}';
}
