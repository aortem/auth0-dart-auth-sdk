/// Represents the request payload to initiate a code or link-based authentication
/// flow with Auth0.
///
/// This request is typically used for sending a verification code or authentication
/// link to a user's email or phone number, based on the type of connection (email
/// or SMS).
///
/// The request includes:
/// - [clientId]: The client identifier for the Auth0 application.
/// - [connection]: The connection type (e.g., "email" or "sms").
class Auth0GetCodeOrLinkRequest {
  /// The client identifier for the Auth0 application.
  final String clientId;

  /// The connection type (e.g., "email", "sms").
  final String connection;

  /// The email or phone number of the user, based on the connection type.
  /// For SMS connections, this should be a phone number; for email-based
  /// connections, this should be the user's email address.
  final String email;

  /// Optional: The type of authentication to send. Can be either 'code' or 'link'.
  final String? send;

  /// Optional: Additional authentication parameters.
  final Map<String, dynamic>? authParams;

  /// Constructs an [Auth0GetCodeOrLinkRequest] with the given [clientId],
  /// [connection], [email], and optional [send] and [authParams].
  ///
  /// Throws an [ArgumentError] if any required fields are empty.
  Auth0GetCodeOrLinkRequest({
    required this.clientId,
    required this.connection,
    required this.email, // or phoneNumber for SMS connection
    this.send,
    this.authParams,
  }) {
    if (clientId.trim().isEmpty) {
      throw ArgumentError('Client ID must not be empty.');
    }
    if (connection.trim().isEmpty) {
      throw ArgumentError('Connection type must not be empty.');
    }
    if (email.trim().isEmpty) {
      throw ArgumentError('Email or phone number must not be empty.');
    }
  }

  /// Converts this request object into a JSON-compatible map for use in HTTP requests.
  ///
  /// The map will contain:
  /// - `client_id`: The client ID of the application.
  /// - `connection`: The connection type (e.g., email or sms).
  /// - `email`: The user's email or phone number.
  /// - `send`: The optional type of authentication to send (either 'code' or 'link').
  /// - `auth_params`: Optional additional authentication parameters.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'client_id': clientId,
      'connection': connection,
      'email': email, // Use 'phone_number' for SMS connection
    };

    if (send != null) {
      data['send'] = send;
    }
    if (authParams != null) {
      data['authParams'] = authParams;
    }

    return data;
  }
}
