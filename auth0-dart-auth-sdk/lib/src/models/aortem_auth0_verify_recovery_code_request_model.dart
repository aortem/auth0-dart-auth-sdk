/// Request model for verifying a recovery code via Auth0's passwordless authentication.
///
/// Contains all required parameters to verify a recovery code and obtain authentication tokens.
class AortemAuth0VerifyRecoveryCodeRequest {
  /// The client ID of the Auth0 application initiating the recovery
  /// This identifies the application in Auth0's system
  /// Must be a non-empty string from Auth0 application settings
  final String clientId;

  /// The recovery code provided by the user
  /// This is typically a one-time use code sent via email or SMS
  /// Must be a non-empty string
  final String recoveryCode;

  /// The username associated with the recovery attempt
  /// For email recovery: the user's email address
  /// For SMS recovery: the user's phone number in E.164 format
  /// Must be a non-empty string
  final String username;

  /// Optional realm specifying the authentication method
  /// Possible values: 'email' or 'sms'
  /// When null, Auth0 will determine the realm automatically
  final String? realm;

  /// Constructs a recovery code verification request
  ///
  /// Parameters:
  ///   [clientId] - Required Auth0 application client ID
  ///   [recoveryCode] - Required recovery code to verify
  ///   [username] - Required user identifier (email/phone)
  ///   [realm] - Optional authentication method ('email' or 'sms')
  ///
  /// Throws:
  ///   [ArgumentError] if any required field is empty
  AortemAuth0VerifyRecoveryCodeRequest({
    required this.clientId,
    required this.recoveryCode,
    required this.username,
    this.realm,
  }) {
    // Validate clientId is not empty
    if (clientId.isEmpty) {
      throw ArgumentError('clientId is required');
    }

    // Validate recoveryCode is not empty
    if (recoveryCode.isEmpty) {
      throw ArgumentError('recoveryCode is required');
    }

    // Validate username is not empty
    if (username.isEmpty) {
      throw ArgumentError('username is required');
    }
  }

  /// Serializes the request to a JSON map for HTTP transmission
  ///
  /// Returns:
  ///   Map with the following structure:
  ///   {
  ///     "grant_type": "passwordless/recovery-code",
  ///     "client_id": "clientId",
  ///     "recovery_code": "recoveryCode",
  ///     "username": "username",
  ///     "realm": "realm" // if provided
  ///   }
  Map<String, dynamic> toJson() {
    return {
      // OAuth 2.0 grant type for passwordless recovery flow
      'grant_type':
          'http://auth0.com/oauth/grant-type/passwordless/recovery-code',

      // Auth0 application identifier
      'client_id': clientId,

      // The recovery code to verify
      'recovery_code': recoveryCode,

      // User's identifier (email/phone)
      'username': username,

      // Include realm only if specified
      if (realm != null) 'realm': realm,
    };
  }
}
