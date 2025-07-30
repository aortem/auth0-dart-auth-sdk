/// Represents a request to initiate a multi-factor authentication (MFA) challenge
/// with Auth0's authentication service.
///
/// This class encapsulates the required parameters for requesting an MFA challenge,
/// which is typically used as part of a multi-step authentication process.
/// The challenge can be of various types (SMS, OTP, push notification, etc.)
/// depending on the user's enrolled MFA factors.
///
/// Example Usage:
/// ```dart
/// final challengeRequest = AortemAuth0ChallengeRequest(
///   mfaToken: 'abc123...', // Token from initial auth attempt
///   challengeType: 'otp',  // Specific challenge type (optional)
/// );
/// ```
class AortemAuth0ChallengeRequest {
  /// The MFA token received from the initial authentication attempt.
  ///
  /// This token is obtained when:
  /// 1. The user successfully provides primary credentials
  /// 2. The system determines MFA is required
  /// 3. The initial auth response includes an mfa_token
  ///
  /// Must not be empty. Typically a JWT or opaque string provided by Auth0.
  final String mfaToken;

  /// Optional: Specifies the type of challenge being requested.
  ///
  /// Common values:
  /// - 'otp': One-time password (TOTP/HOTP)
  /// - 'sms': SMS verification code
  /// - 'push': Push notification
  /// - 'email': Email verification
  ///
  /// If null, Auth0 will determine the appropriate challenge type
  /// based on the user's enrolled factors.
  final String? challengeType;

  /// Creates an MFA challenge request instance.
  ///
  /// Parameters:
  /// - [mfaToken]: Required token from initial auth attempt
  /// - [challengeType]: Optional preferred challenge method
  ///
  /// Throws:
  /// - [ArgumentError] if mfaToken is empty
  AortemAuth0ChallengeRequest({required this.mfaToken, this.challengeType}) {
    if (mfaToken.isEmpty) {
      throw ArgumentError('mfaToken cannot be empty.');
    }
  }

  /// Serializes the request to a JSON format suitable for Auth0's API.
  ///
  /// The resulting map follows Auth0's expected structure for challenge requests.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` containing:
  /// - 'mfa_token': The MFA token (always included)
  /// - 'challenge_type': The challenge type (if specified)
  ///
  /// Example Output:
  /// ```json
  /// {
  ///   "mfa_token": "abc123...",
  ///   "challenge_type": "otp"
  /// }
  /// ```
  Map<String, dynamic> toJson() => {
    'mfa_token': mfaToken,
    if (challengeType != null) 'challenge_type': challengeType,
  };
}
