/// Represents the response received after initiating a back-channel
/// login request with Auth0.
///
/// This response typically includes an `authReqId` that is used to poll
/// for authentication results, an expiration time, and an optional
/// polling interval to respect between authentication status checks.
class Auth0BackChannelLoginResponse {
  /// The unique identifier for the back-channel authentication request.
  ///
  /// This ID is used in subsequent polling requests to check the status
  /// of the authentication process.
  final String authReqId;

  /// The number of seconds after which the authentication request expires.
  final int expiresIn;

  /// Optional suggested polling interval in seconds.
  ///
  /// Clients should wait this number of seconds between polling attempts.
  final int? interval;

  /// Creates an [Auth0BackChannelLoginResponse] with the given
  /// [authReqId], [expiresIn], and optional [interval].
  Auth0BackChannelLoginResponse({
    required this.authReqId,
    required this.expiresIn,
    this.interval,
  });

  /// Creates an instance of [Auth0BackChannelLoginResponse] from a JSON map.
  ///
  /// Throws a [FormatException] if required fields are missing.
  factory Auth0BackChannelLoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['auth_req_id'] == null || json['expires_in'] == null) {
      throw FormatException('Missing required fields in Auth0 response');
    }

    return Auth0BackChannelLoginResponse(
      authReqId: json['auth_req_id'] as String,
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int?,
    );
  }
}
