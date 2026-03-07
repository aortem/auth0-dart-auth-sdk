/// Represents the request model to retrieve a user profile from Auth0.
///
/// This request typically requires an access token that was issued
/// during the authentication or authorization flow.
class Auth0UserProfileRequest {
  /// The access token used to authorize the request.
  final String accessToken;

  /// Constructs an [Auth0UserProfileRequest] with the given [accessToken].
  ///
  /// Throws an [ArgumentError] if the access token is empty.
  Auth0UserProfileRequest({required this.accessToken}) {
    if (accessToken.trim().isEmpty) {
      throw ArgumentError('Access token must not be empty.');
    }
  }

  /// Converts this request to a JSON-compatible map.
  ///
  /// This can be useful if making a POST request where the access token
  /// is expected in the request body.
  Map<String, dynamic> toJson() {
    return {'access_token': accessToken};
  }
}
