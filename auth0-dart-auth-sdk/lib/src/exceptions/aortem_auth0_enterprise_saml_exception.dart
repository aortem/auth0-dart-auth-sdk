/// Exception thrown when enterprise SAML authentication fails
/// in the Auth0 authentication flow.
///
/// This exception captures a descriptive error message,
/// an optional HTTP status code from the server, and
/// any additional error details such as a response payload or
/// structured error object.
class AortemAuth0EnterpriseSamlException implements Exception {
  /// A human-readable description of the error.
  final String message;

  /// Optional HTTP status code returned by the Auth0 or SAML endpoint.
  final int? statusCode;

  /// Optional additional error information, such as a response body
  /// or structured error details.
  final dynamic errorDetails;

  /// Constructs an [AortemAuth0EnterpriseSamlException] with the given [message],
  /// and optionally a [statusCode] and [errorDetails] for more context.
  AortemAuth0EnterpriseSamlException({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });

  @override
  String toString() => 'AortemAuth0EnterpriseSamlException: $message'
      '${statusCode != null ? ' (Status: $statusCode)' : ''}'
      '${errorDetails != null ? '\nDetails: $errorDetails' : ''}';
}
