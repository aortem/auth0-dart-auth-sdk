/// Represents the user profile response returned by Auth0.
///
/// This model includes basic profile information such as user ID, name,
/// email, and profile picture URL.
class AortemAuth0UserProfileResponse {
  /// The subject identifier for the user (usually in the format `provider|user_id`).
  final String sub;

  /// The full name of the user.
  final String name;

  /// The user's email address.
  final String email;

  /// The URL to the user's profile picture.
  final String picture;

  /// Constructs an [AortemAuth0UserProfileResponse] with the provided fields.
  AortemAuth0UserProfileResponse({
    required this.sub,
    required this.name,
    required this.email,
    required this.picture,
  });

  /// Creates an instance of [AortemAuth0UserProfileResponse] from a JSON map.
  ///
  /// This method parses the Auth0 user profile response into a Dart object.
  ///
  /// Example response from Auth0:
  /// ```json
  /// {
  ///   "sub": "auth0|123456789",
  ///   "name": "Jane Doe",
  ///   "email": "jane.doe@example.com",
  ///   "picture": "https://example.com/photo.jpg"
  /// }
  /// ```
  factory AortemAuth0UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return AortemAuth0UserProfileResponse(
      sub: json['sub'],
      name: json['name'],
      email: json['email'],
      picture: json['picture'],
    );
  }
}
