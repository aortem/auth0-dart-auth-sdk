/// Represents the response from a signup request in Auth0.
///
/// This class holds the data returned after a successful signup request, including
/// the user's email and an optional user ID.
class AortemAuth0SignupResponse {
  /// The email address of the user that was signed up.
  final String email;

  /// Optional: The user ID generated by Auth0 after the signup.
  final String? userId;

  /// Constructs an [AortemAuth0SignupResponse] with the given fields.
  AortemAuth0SignupResponse({
    required this.email,
    this.userId,
  });

  /// Creates an instance of [AortemAuth0SignupResponse] from a JSON map.
  ///
  /// This factory method takes a JSON response and maps it to the corresponding
  /// fields in the response class. The `email` is required, while the `user_id`
  /// is optional.
  factory AortemAuth0SignupResponse.fromJson(Map<String, dynamic> json) {
    return AortemAuth0SignupResponse(
      email: json['email'],
      userId: json['user_id'],
    );
  }
}
