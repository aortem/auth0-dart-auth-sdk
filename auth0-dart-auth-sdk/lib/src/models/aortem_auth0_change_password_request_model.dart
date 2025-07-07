/// Represents a request to change a user's password in Auth0.
///
/// This class contains the necessary information required by Auth0's
/// change password endpoint, including the client ID, user email,
/// and connection type.
class AortemAuth0ChangePasswordRequest {
  /// The client ID of the Auth0 application.
  final String clientId;

  /// The email address of the user requesting a password change.
  final String email;

  /// The Auth0 connection type (e.g., 'Username-Password-Authentication').
  final String connection;

  /// Creates an [AortemAuth0ChangePasswordRequest] instance.
  ///
  /// [clientId]: The Auth0 application client ID (required).
  /// [email]: The email address of the user (required).
  /// [connection]: The Auth0 connection name (required).
  AortemAuth0ChangePasswordRequest({
    required this.clientId,
    required this.email,
    required this.connection,
  });

  /// Converts this request object to a JSON map suitable for sending to Auth0.
  ///
  /// Returns a [Map<String, dynamic>] with keys:
  /// - 'client_id': The client ID
  /// - 'email': The user's email
  /// - 'connection': The connection type
  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'email': email,
      'connection': connection,
    };
  }
}
