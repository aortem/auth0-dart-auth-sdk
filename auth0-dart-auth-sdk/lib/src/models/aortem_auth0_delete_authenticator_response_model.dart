/// Represents the response from deleting an MFA (Multi-Factor Authentication) authenticator.
///
/// This model contains the result of an authenticator deletion operation,
/// including success status and an optional message describing the outcome.
/// It is typically returned by Auth0's MFA API after attempting to remove
/// an authenticator from a user's account.
class AortemAuth0DeleteAuthenticatorResponse {
  /// A human-readable message describing the result of the deletion operation.
  ///
  /// For successful deletions, this typically confirms the removal.
  /// For failures, it may contain error details or reasons for failure.
  /// Example: "Authenticator deleted successfully" or "Authenticator not found"
  final String message;

  /// Indicates whether the deletion operation was successful.
  ///
  /// - `true`: The authenticator was successfully removed
  /// - `false`: The deletion failed (check message for details)
  final bool success;

  /// Creates a new [AortemAuth0DeleteAuthenticatorResponse] instance.
  ///
  /// Both [message] and [success] are required parameters that must be provided.
  /// [message] should be a non-empty string describing the operation result.
  AortemAuth0DeleteAuthenticatorResponse({
    required this.message,
    required this.success,
  });

  /// Parses a JSON map into an [AortemAuth0DeleteAuthenticatorResponse] object.
  ///
  /// Expected JSON format:
  /// ```json
  /// {
  ///   "message": "Authenticator deleted successfully",
  ///   "success": true
  /// }
  /// ```
  ///
  /// Throws:
  /// - [FormatException] if required fields are missing or invalid types
  /// - [TypeError] if JSON values cannot be cast to expected types
  factory AortemAuth0DeleteAuthenticatorResponse.fromJson(
      Map<String, dynamic> json) {
    return AortemAuth0DeleteAuthenticatorResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
    );
  }
}
