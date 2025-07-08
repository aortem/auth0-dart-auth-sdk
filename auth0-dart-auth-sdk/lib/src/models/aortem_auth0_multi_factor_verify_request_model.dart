/// Represents a request to verify a multi-factor authentication (MFA) challenge with Auth0.
///
/// This class encapsulates the required parameters needed to verify
/// a one-time password (OTP) during an MFA flow with Auth0.
///
/// The [mfaToken] is obtained from the initial authentication attempt when MFA is required,
/// and the [otp] is the code provided by the user (typically from an authenticator app or SMS).
///
/// Example usage:
/// ```dart
/// final request = AortemAuth0MultiFactorVerifyRequest(
///   mfaToken: 'received_mfa_token',
///   otp: 'user_provided_code',
/// );
/// final response = await auth0Client.verifyMfaChallenge(request);
/// ```
class AortemAuth0MultiFactorVerifyRequest {
  /// The MFA token received from Auth0 when MFA is required.
  ///
  /// This token is provided in the initial authentication response when
  /// the user needs to complete multi-factor authentication.
  /// It identifies the specific MFA challenge being verified.
  final String mfaToken;

  /// The one-time password provided by the user for MFA verification.
  ///
  /// This is typically a 6-digit code from an authenticator app or
  /// received via SMS. Must be a non-empty string.
  final String otp;

  /// Creates a request to verify an MFA challenge.
  ///
  /// Both [mfaToken] and [otp] are required and must be non-empty strings.
  AortemAuth0MultiFactorVerifyRequest({
    required this.mfaToken,
    required this.otp,
  });

  /// Serializes this request to a JSON map suitable for sending to Auth0's API.
  ///
  /// The resulting map will have keys 'mfa_token' and 'otp' with their
  /// corresponding values.
  Map<String, dynamic> toJson() => {
        'mfa_token': mfaToken,
        'otp': otp,
      };
}
