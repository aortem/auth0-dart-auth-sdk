/// Exception thrown when passive authentication fails using
/// a database, Active Directory (AD), or LDAP connection
/// during the Auth0 authentication process.
///
/// Passive authentication typically refers to a login attempt
/// that occurs without explicit user interaction, often in SSO
/// or federated identity scenarios.
///
/// This exception includes a human-readable message, an optional
/// HTTP status code, and additional error details for troubleshooting.
class AortemAuth0DatabaseAdLdapPassiveException implements Exception {
  /// A human-readable message describing the error.
  final String message;

  /// Optional HTTP status code returned by the identity provider or Auth0.
  final int? statusCode;

  /// Optional additional error information such as a response body,
  /// stack trace, or structured error payload.
  final dynamic errorDetails;

  /// Constructs an [AortemAuth0DatabaseAdLdapPassiveException] with the given [message],
  /// and optionally a [statusCode] and [errorDetails] for additional context.
  AortemAuth0DatabaseAdLdapPassiveException({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });

  @override
  String toString() =>
      'AortemAuth0DatabaseAdLdapPassiveException: $message'
      '${statusCode != null ? ' (Status: $statusCode)' : ''}'
      '${errorDetails != null ? '\nDetails: $errorDetails' : ''}';
}
