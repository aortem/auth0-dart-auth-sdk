/// Represents a request to verify a One-Time Password (OTP) with Auth0's passwordless authentication.
///
/// This class encapsulates all parameters required to verify an OTP sent via email or SMS
/// as part of Auth0's passwordless authentication flow. The request varies slightly depending
/// on whether the OTP was delivered via email or SMS.
///
/// Usage Examples:
///
/// For email OTP verification:
/// ```dart
/// final request = Auth0VerifyOTPRequest(
///   clientId: 'YOUR_CLIENT_ID',
///   otp: '123456',
///   realm: 'email',
///   username: 'user@example.com',
/// );
/// ```
///
/// For SMS OTP verification:
/// ```dart
/// final request = Auth0VerifyOTPRequest(
///   clientId: 'YOUR_CLIENT_ID',
///   otp: '123456',
///   realm: 'sms',
///   phoneNumber: '+15551234567',
/// );
/// ```
class Auth0VerifyOTPRequest {
  /// The client ID of the Auth0 application initiating the verification.
  ///
  /// This identifies your application in Auth0 and is required for all authentication requests.
  /// Obtain this value from your Auth0 application settings.
  final String clientId;

  /// The one-time password to verify.
  ///
  /// This is the code that was sent to the user's email or phone number.
  /// Typically a 6-digit numeric code, but the format depends on your Auth0 configuration.
  final String otp;

  /// The authentication realm indicating the OTP delivery method.
  ///
  /// Supported values:
  /// - 'email': For OTPs sent via email
  /// - 'sms': For OTPs sent via SMS
  ///
  /// This determines which additional fields are required (username for email, phoneNumber for SMS).
  final String realm;

  /// The user's email address (required when realm is 'email').
  ///
  /// This must match the email address to which the OTP was sent.
  /// Only required when realm is 'email'.
  final String? username;

  /// The user's phone number (required when realm is 'sms').
  ///
  /// This must match the phone number to which the OTP was sent in E.164 format.
  /// Only required when realm is 'sms'.
  final String? phoneNumber;

  /// Creates a new OTP verification request.
  ///
  /// Parameters:
  /// - [clientId]: Required application client ID
  /// - [otp]: Required one-time password to verify
  /// - [realm]: Required authentication method ('email' or 'sms')
  /// - [username]: Required when realm is 'email'
  /// - [phoneNumber]: Required when realm is 'sms'
  ///
  /// Throws:
  /// - [ArgumentError] if:
  ///   - Realm is 'email' but username is not provided
  ///   - Realm is 'sms' but phoneNumber is not provided
  Auth0VerifyOTPRequest({
    required this.clientId,
    required this.otp,
    required this.realm,
    this.username,
    this.phoneNumber,
  }) {
    if (realm == 'email' && (username == null || username!.isEmpty)) {
      throw ArgumentError('Username is required when realm is "email".');
    }
    if (realm == 'sms' && (phoneNumber == null || phoneNumber!.isEmpty)) {
      throw ArgumentError('Phone number is required when realm is "sms".');
    }
  }

  /// Converts this request to a JSON map suitable for Auth0's OTP verification endpoint.
  ///
  /// The resulting JSON structure follows Auth0's expected format for OTP verification,
  /// including the appropriate grant type and conditional fields based on the realm.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` containing:
  /// - grant_type: Always set to passwordless OTP grant type
  /// - client_id: The application client ID
  /// - otp: The one-time password
  /// - realm: The authentication method
  /// - username: Either the email or phone number, depending on realm
  Map<String, dynamic> toJson() {
    final map = {
      'grant_type': 'http://auth0.com/oauth/grant-type/passwordless/otp',
      'client_id': clientId,
      'otp': otp,
      'realm': realm,
    };

    // Include the appropriate username field based on realm
    if (realm == 'email') {
      map['username'] = username!;
    } else if (realm == 'sms') {
      map['username'] = phoneNumber!;
    }

    return map;
  }
}
