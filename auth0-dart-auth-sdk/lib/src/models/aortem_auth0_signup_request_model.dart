/// Represents the request payload for signing up a new user in Auth0.
///
/// This class holds the necessary data for initiating a signup request in the
/// Auth0 platform. The `email`, `password`, and `connection` fields are required,
/// while `username` and `userMetadata` are optional.
class AortemAuth0SignupRequest {
  /// The client identifier for the Auth0 application.
  final String clientId;

  /// The email address of the user to be signed up.
  final String email;

  /// The password for the user account.
  final String password;

  /// The Auth0 connection (database or enterprise) used for the signup process.
  final String connection;

  /// Optional: The username for the user, if applicable.
  final String? username;

  /// Optional: Additional metadata about the user.
  final Map<String, dynamic>? userMetadata;

  /// Constructs an [AortemAuth0SignupRequest] with the required and optional fields.
  AortemAuth0SignupRequest({
    required this.clientId,
    required this.email,
    required this.password,
    required this.connection,
    this.username,
    this.userMetadata,
  });

  /// Converts this instance into a JSON map.
  ///
  /// This method prepares the request data for submission by converting the
  /// fields into a map of key-value pairs. Null values are removed from the map
  /// to ensure only valid data is included.
  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'email': email,
      'password': password,
      'connection': connection,
      'username': username,
      'user_metadata': userMetadata,
    }..removeWhere((key, value) => value == null); // Remove null values
  }
}
