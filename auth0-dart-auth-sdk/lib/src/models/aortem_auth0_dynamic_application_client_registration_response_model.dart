/// A response model representing the Auth0 application authorization URL.
class AortemAuth0AuthorizeApplicationClientRegisterResponse {
  /// The generated authorization URL for initiating the OAuth2 flow.
  final Uri url;

  /// Constructs an [AortemAuth0AuthorizeApplicationClientRegisterResponse].
  AortemAuth0AuthorizeApplicationClientRegisterResponse({required this.url});
}
