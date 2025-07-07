/// Represents a Multi-Factor Authentication (MFA) authenticator registered in Auth0.
///
/// This model contains details about a single authenticator that a user has enrolled
/// for MFA purposes. Authenticators can be of various types such as:
/// - Authenticator apps (TOTP)
/// - SMS verification
/// - Biometric authenticators
/// - Security keys (WebAuthn)
///
/// Each authenticator has a unique identifier and metadata about its configuration.
class AortemAuth0Authenticator {
  /// The unique identifier for this authenticator.
  ///
  /// This ID is used when performing operations on specific authenticators,
  /// such as deletion or updating.
  final String id;

  /// The type of authenticator.
  ///
  /// Common values include:
  /// - 'totp' (Time-based One-Time Password apps)
  /// - 'sms' (SMS verification)
  /// - 'webauthn' (Security keys/biometrics)
  /// - 'recovery-code' (Backup codes)
  final String type;

  /// A human-readable name for the authenticator.
  ///
  /// This is typically user-provided during enrollment to help identify
  /// the authenticator (e.g., "My Phone" or "Work Authenticator App").
  final String name;

  /// The date when this authenticator was enrolled, if available.
  ///
  /// Format is typically ISO 8601 (e.g., "2023-01-15T12:34:56.789Z").
  /// This field may be null for some authenticator types or older enrollments.
  final String? enrollmentDate;

  /// Creates a new [AortemAuth0Authenticator] instance.
  ///
  /// [id], [type], and [name] are required fields that must be non-empty.
  /// [enrollmentDate] is optional and may be null.
  AortemAuth0Authenticator({
    required this.id,
    required this.type,
    required this.name,
    this.enrollmentDate,
  });

  /// Creates an [AortemAuth0Authenticator] from a JSON map.
  ///
  /// The JSON structure should match the format returned by Auth0's MFA API.
  /// Expected format:
  /// ```json
  /// {
  ///   "id": "auth_123456",
  ///   "type": "totp",
  ///   "name": "Google Authenticator",
  ///   "enrollment_date": "2023-01-15T12:34:56.789Z"
  /// }
  /// ```
  ///
  /// Throws:
  /// - [FormatException] if required fields are missing or invalid
  factory AortemAuth0Authenticator.fromJson(Map<String, dynamic> json) {
    return AortemAuth0Authenticator(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      enrollmentDate: json['enrollment_date'] as String?,
    );
  }
}
