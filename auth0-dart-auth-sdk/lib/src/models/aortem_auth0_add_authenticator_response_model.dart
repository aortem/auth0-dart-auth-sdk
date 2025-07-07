/// Response model for adding an authenticator to Auth0.
///
/// This model represents the response returned from Auth0 when adding
/// an authenticator for multi-factor authentication (MFA). It contains
/// the secret key and the URL to the QR code used for configuring the
/// authenticator app.
class AortemAuth0AddAuthenticatorResponse {
  /// The secret key used for configuring the authenticator.
  final String secret;

  /// The URL to the QR code used for configuring the authenticator.
  final String qrCodeUrl;

  /// Constructs an instance of [AortemAuth0AddAuthenticatorResponse].
  ///
  /// [secret] is the secret key returned by Auth0 that is used for MFA setup.
  /// [qrCodeUrl] is the URL to the QR code image that can be scanned by an authenticator app.
  AortemAuth0AddAuthenticatorResponse({
    required this.secret,
    required this.qrCodeUrl,
  });

  /// Creates an instance of [AortemAuth0AddAuthenticatorResponse] from a JSON map.
  ///
  /// The [json] map is expected to contain the `secret` and `qrCodeUrl` fields,
  /// which are required to instantiate the response object.
  ///
  /// Throws a [FormatException] if the required fields are not found or the
  /// response does not contain valid data.
  factory AortemAuth0AddAuthenticatorResponse.fromJson(
      Map<String, dynamic> json) {
    return AortemAuth0AddAuthenticatorResponse(
      secret: json['secret'], // Extracts the 'secret' from the JSON response.
      qrCodeUrl:
          json['qrCodeUrl'], // Extracts the 'qrCodeUrl' from the JSON response.
    );
  }
}
