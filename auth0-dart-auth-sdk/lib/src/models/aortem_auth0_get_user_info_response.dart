/// Represents the user information response from Auth0's /userinfo endpoint.
///
/// This class encapsulates the standard claims returned by Auth0's OIDC-compliant
/// user info endpoint, along with any additional claims that might be present.
/// Standard claims include user identifiers (sub), profile information (name, picture),
/// and contact details (email).
///
/// Example:
/// ```dart
/// final userInfo = AortemAuth0GetUserInfoResponse.fromJson(responseData);
/// print('User ID: ${userInfo.sub}');
/// print('Email: ${userInfo.email}');
/// ```
class AortemAuth0GetUserInfoResponse {
  /// The unique identifier for the user (subject identifier).
  ///
  /// This is the preferred unique identifier for the user, guaranteed to be unique
  /// within the Auth0 tenant and never reassigned to another user.
  final String sub;

  /// The full name of the user.
  ///
  /// This may include first and last name. Null if not provided by the identity provider.
  final String? name;

  /// The email address of the user.
  ///
  /// Null if not provided by the identity provider or if email scope wasn't requested.
  final String? email;

  /// URL of the user's profile picture.
  ///
  /// Null if not provided by the identity provider.
  final String? picture;

  /// Additional claims returned by the user info endpoint.
  ///
  /// Contains all claims not explicitly mapped to other properties (sub, name, email, picture).
  /// This may include custom claims or claims from connected identity providers.
  final Map<String, dynamic> additionalClaims;

  /// Creates an [AortemAuth0GetUserInfoResponse] instance.
  ///
  /// [sub] is required as it represents the unique user identifier.
  /// All other fields are optional and may be null depending on the scopes requested
  /// and the information available from the identity provider.
  AortemAuth0GetUserInfoResponse({
    required this.sub,
    this.name,
    this.email,
    this.picture,
    this.additionalClaims = const {},
  });

  /// Parses a JSON map into an [AortemAuth0GetUserInfoResponse] instance.
  ///
  /// The [json] parameter should contain the response from Auth0's /userinfo endpoint.
  /// Standard claims (sub, name, email, picture) are extracted and all remaining claims
  /// are stored in [additionalClaims].
  ///
  /// Throws if:
  /// - [json] is missing the required 'sub' field
  /// - [json] is not a valid Map<String, dynamic>
  factory AortemAuth0GetUserInfoResponse.fromJson(Map<String, dynamic> json) {
    return AortemAuth0GetUserInfoResponse(
      sub: json['sub'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      picture: json['picture'] as String?,
      additionalClaims: Map<String, dynamic>.from(json)
        ..removeWhere(
            (key, _) => ['sub', 'name', 'email', 'picture'].contains(key)),
    );
  }
}
