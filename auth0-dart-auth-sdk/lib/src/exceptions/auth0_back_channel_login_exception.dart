/// Exception thrown when a back-channel login request fails in the
/// Auth0 authentication process.
///
/// This exception can capture an error message, an optional HTTP
/// status code, and any additional error details returned by the
/// Auth0 service.
class Auth0BackChannelLoginException implements Exception {
  /// A human-readable description of the error.
  final String message;

  /// Optional HTTP status code returned by the Auth0 API.
  final int? statusCode;

  /// Optional additional error information, such as a response body or
  /// structured error data.
  final dynamic errorDetails;

  /// Creates an instance of [Auth0BackChannelLoginException].
  ///
  /// The [message] parameter is required. [statusCode] and [errorDetails]
  /// are optional and may provide more context about the error.
  Auth0BackChannelLoginException({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });

  @override
  String toString() =>
      'Auth0BackChannelLoginException: $message'
      '${statusCode != null ? ' (Status: $statusCode)' : ''}'
      '${errorDetails != null ? '\nDetails: $errorDetails' : ''}';
}
