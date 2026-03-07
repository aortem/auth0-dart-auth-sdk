/// Exception thrown when accepting a passwordless authentication request fails.
///
/// Contains details about what went wrong during the request.
class Auth0AcceptRequestException implements Exception {
  /// A message describing the error that occurred.
  final String message;

  /// Creates a new [Auth0AcceptRequestException] with the given [message].
  Auth0AcceptRequestException(this.message);

  @override
  String toString() => 'Auth0AcceptRequestException: $message';
}
