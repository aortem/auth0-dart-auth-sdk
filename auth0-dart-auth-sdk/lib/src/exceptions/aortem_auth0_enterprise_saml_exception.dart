/// Exception thrown when enterprise SAML authentication fails
/// in the Auth0 authentication flow.
///
/// This exception provides detailed information about failures that occur
/// during the SAML enterprise authentication process with Auth0.
/// It includes an error message, optional status code, and additional error details.
///
/// Example usage:
/// ```dart
/// throw AortemAuth0EnterpriseSamlException(
///   message: 'SAML authentication failed',
///   statusCode: 401,
///   errorDetails: {'reason': 'invalid_credentials'},
/// );
/// ```
class AortemAuth0EnterpriseSamlException implements Exception {
  /// A human-readable error message describing the failure
  final String message;

  /// The HTTP status code associated with the error, if available
  final int? statusCode;

  /// Additional error details that might help diagnose the problem
  /// Can be of any type (Map, List, String, etc.)
  final dynamic errorDetails;

  /// Creates a new SAML authentication exception
  ///
  /// [message]: Required description of the error
  /// [statusCode]: Optional HTTP status code
  /// [errorDetails]: Optional additional error information
  AortemAuth0EnterpriseSamlException({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });

  /// Returns a string representation of the exception
  ///
  /// Format includes:
  /// - Exception type name
  /// - Error message
  /// - Status code (if present)
  /// - Error details (if present)
  @override
  String toString() => 'AortemAuth0EnterpriseSamlException: $message'
      '${statusCode != null ? ' (Status: $statusCode)' : ''}'
      '${errorDetails != null ? '\nDetails: $errorDetails' : ''}';
}