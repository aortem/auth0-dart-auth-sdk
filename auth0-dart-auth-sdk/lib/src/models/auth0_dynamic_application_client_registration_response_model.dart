/// A response model representing the Auth0 application authorization URL.
class Auth0AuthorizeApplicationClientRegisterResponse {
  /// The generated authorization URL for initiating the OAuth2 flow.
  final Uri url;

  /// Constructs an [Auth0AuthorizeApplicationClientRegisterResponse].
  Auth0AuthorizeApplicationClientRegisterResponse({required this.url});
}
