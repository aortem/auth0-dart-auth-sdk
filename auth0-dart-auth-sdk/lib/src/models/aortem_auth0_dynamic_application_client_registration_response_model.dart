/// A response model representing the Auth0 application authorization URL.
class AortemAuth0AuthorizeApplicationResponse {
  /// The generated authorization URL for initiating the OAuth2 flow.
  final Uri url;

  /// Constructs an [AortemAuth0AuthorizeApplicationResponse].
  AortemAuth0AuthorizeApplicationResponse({required this.url});
}
