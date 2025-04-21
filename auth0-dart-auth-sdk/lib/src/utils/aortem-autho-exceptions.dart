/// Custom exception class for handling Auth0 Social Login errors.
class AortemAuth0SocialLoginException implements Exception {
  final String message;
  AortemAuth0SocialLoginException(this.message);

  @override
  String toString() => 'AortemAuth0SocialLoginException: $message';
}
