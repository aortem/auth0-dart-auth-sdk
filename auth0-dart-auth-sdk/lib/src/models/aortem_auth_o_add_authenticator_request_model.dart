/// Represents a request to add a new authenticator for Multi-Factor Authentication (MFA)
/// in Auth0's authentication system.
///
/// This class encapsulates the required parameters for registering a new MFA authenticator
/// (such as TOTP, SMS, or push notification) with Auth0.
///
/// Usage Example:
/// ```dart
/// final request = AortemAuth0AddAuthenticatorRequest(
///   mfaToken: 'abc123xyz...', // From initial auth response
///   authenticatorType: 'otp', // Type of authenticator to add
/// );
/// ```
class AortemAuth0AddAuthenticatorRequest {
  /// The MFA token obtained from the initial authentication response.
  ///
  /// This token is required to associate the new authenticator with the current
  /// authentication session. It is typically provided when:
  /// 1. The user successfully authenticates with primary credentials
  /// 2. The system determines MFA enrollment is required or pending
  ///
  /// Must be a non-empty string.
  final String mfaToken;

  /// The type of authenticator being added.
  ///
  /// Supported values (depending on Auth0 configuration):
  /// - 'otp': Time-based one-time password (TOTP) authenticator
  /// - 'sms': SMS-based verification
  /// - 'push': Push notification via Auth0 Guardian
  /// - 'webauthn-roaming': Cross-platform WebAuthn authenticator
  /// - 'webauthn-platform': Platform-specific WebAuthn authenticator
  ///
  /// Must be a non-empty string matching one of Auth0's supported types.
  final String authenticatorType;

  /// Creates a request to add a new MFA authenticator.
  ///
  /// Parameters:
  /// - [mfaToken]: Required token from initial authentication
  /// - [authenticatorType]: Required type of authenticator to add
  ///
  /// Throws:
  /// - [ArgumentError] if either parameter is empty
  AortemAuth0AddAuthenticatorRequest({
    required this.mfaToken,
    required this.authenticatorType,
  }) {
    // Validate that required fields are not empty
    if (mfaToken.isEmpty || authenticatorType.isEmpty) {
      throw ArgumentError('mfaToken and authenticatorType cannot be empty');
    }
  }

  /// Converts the request to a JSON map suitable for Auth0's API.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` with the following structure:
  /// {
  ///   "mfa_token": "mfaToken",
  ///   "authenticator_type": ""
  /// }
  Map<String, dynamic> toJson() => {
        'mfa_token': mfaToken,
        'authenticator_type': authenticatorType,
      };
}
