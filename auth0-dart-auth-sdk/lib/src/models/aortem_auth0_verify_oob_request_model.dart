/// A model class representing the request payload for verifying an
/// out-of-band (OOB) code in a passwordless login flow using Auth0.
///
/// The OOB flow is used for passwordless authentication via either
/// email or SMS. This class handles validation and conversion of the
/// required fields for making a token request to the Auth0 `/oauth/token`
/// endpoint with the OOB grant.
///
/// The `realm` field determines the delivery mechanism (`email` or `sms`),
/// and based on that, either the `username` or `phoneNumber` is required.
///
/// Example usage:
/// ```dart
/// final request = AortemAuth0VerifyOOBRequest(
///   clientId: 'your-client-id',
///   oobCode: 'received-oob-code',
///   realm: 'email',
///   username: 'user@example.com',
/// );
/// final body = request.toJson();
/// ```
class AortemAuth0VerifyOOBRequest {
  /// The Auth0 client ID of the application.
  final String clientId;

  /// The OOB (out-of-band) verification code received via email or SMS.
  final String oobCode;

  /// The authentication realm, typically `email` or `sms`.
  final String realm;

  /// The user's email address (required if realm is `email`).
  final String? username;

  /// The user's phone number (required if realm is `sms`).
  final String? phoneNumber;

  /// Constructs a [AortemAuth0VerifyOOBRequest] instance and validates input.
  ///
  /// Throws [ArgumentError] if any required parameter is missing or invalid.
  AortemAuth0VerifyOOBRequest({
    required this.clientId,
    required this.oobCode,
    required this.realm,
    this.username,
    this.phoneNumber,
  }) {
    if (clientId.isEmpty) {
      throw ArgumentError('Client ID is required.');
    }
    if (oobCode.isEmpty) {
      throw ArgumentError('OOB code is required.');
    }
    if (realm.isEmpty) {
      throw ArgumentError('Realm is required.');
    }
    if (realm == 'email' && (username == null || username!.isEmpty)) {
      throw ArgumentError('Username is required for email realm.');
    }
    if (realm == 'sms' && (phoneNumber == null || phoneNumber!.isEmpty)) {
      throw ArgumentError('Phone number is required for sms realm.');
    }
  }

  /// Converts the request data into a JSON map that matches Auth0's
  /// expected payload for OOB passwordless grant verification.
  ///
  /// Includes conditional fields (`username` or `phone_number`) based on realm.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'grant_type': 'http://auth0.com/oauth/grant-type/passwordless/oob',
      'client_id': clientId,
      'oob_code': oobCode,
      'realm': realm,
    };

    if (realm == 'email') {
      map['username'] = username;
    } else if (realm == 'sms') {
      map['phone_number'] = phoneNumber;
    }

    return map;
  }
}
