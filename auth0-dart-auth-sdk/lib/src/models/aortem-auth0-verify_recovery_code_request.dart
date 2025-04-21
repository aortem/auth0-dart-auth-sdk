/// Represents a request to verify a recovery code for passwordless authentication with Auth0.
///
/// This class encapsulates the parameters required to verify a one-time recovery code
/// as part of Auth0's passwordless authentication flow. Recovery codes are typically
/// used when the user doesn't have access to their primary authentication device.
///
/// Example usage:
/// ```dart
/// final request = AortemAuth0VerifyRecoveryCodeRequest(
///   clientId: 'YOUR_AUTH0_CLIENT_ID',
///   recoveryCode: 'USER_RECOVERY_CODE',
///   username: 'user@example.com',
///   realm: 'email', // optional connection realm
/// );
///
/// final response = await auth0Client.verifyRecoveryCode(request);
/// ```
///
/// Throws:
/// - [ArgumentError] if any required field is empty
class AortemAuth0VerifyRecoveryCodeRequest {
  /// The Auth0 application client ID.
  ///
  /// This identifies the application making the request and must match
  /// the client ID used in the original authentication flow.
  final String clientId;

  /// The recovery code provided by the user.
  ///
  /// This is the one-time code that was previously generated and sent to the user
  /// as part of the passwordless authentication setup.
  final String recoveryCode;

  /// The username or email address associated with the account.
  ///
  /// This should match the identifier used in the original authentication request.
  final String username;

  /// The authentication realm or connection name.
  ///
  /// This is optional and typically used to specify the connection type (e.g., 'email' or 'sms')
  /// when multiple passwordless connections are configured.
  final String? realm;

  /// Creates a recovery code verification request.
  ///
  /// Required parameters:
  /// - [clientId]: Your Auth0 application's client ID
  /// - [recoveryCode]: The user's recovery code
  /// - [username]: The user's identifier (email or username)
  ///
  /// Optional parameters:
  /// - [realm]: The connection realm (e.g., 'email')
  ///
  /// Throws:
  /// - [ArgumentError] if [clientId], [recoveryCode], or [username] are empty
  AortemAuth0VerifyRecoveryCodeRequest({
    required this.clientId,
    required this.recoveryCode,
    required this.username,
    this.realm,
  }) {
    if (clientId.isEmpty) throw ArgumentError('clientId is required');
    if (recoveryCode.isEmpty) throw ArgumentError('recoveryCode is required');
    if (username.isEmpty) throw ArgumentError('username is required');
  }

  /// Serializes this request to a JSON map suitable for the Auth0 API.
  ///
  /// The resulting JSON will include:
  /// - The passwordless recovery code grant type
  /// - Client ID
  /// - Recovery code
  /// - Username
  /// - Realm (if specified)
  ///
  /// Example output:
  /// ```json
  /// {
  ///   "grant_type": "http://auth0.com/oauth/grant-type/passwordless/recovery-code",
  ///   "client_id": "YOUR_CLIENT_ID",
  ///   "recovery_code": "USER_CODE",
  ///   "username": "user@example.com",
  ///   "realm": "email"
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'grant_type':
          'http://auth0.com/oauth/grant-type/passwordless/recovery-code',
      'client_id': clientId,
      'recovery_code': recoveryCode,
      'username': username,
      if (realm != null) 'realm': realm,
    };
  }
}
