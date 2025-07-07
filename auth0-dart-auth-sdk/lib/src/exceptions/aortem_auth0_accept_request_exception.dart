/// Exception thrown when accepting a passwordless authentication request fails.
///
/// Contains details about what went wrong during the request.
class AortemAuth0AcceptRequestException implements Exception {
  /// A message describing the error that occurred.
  final String message;

  /// Creates a new [AortemAuth0AcceptRequestException] with the given [message].
  AortemAuth0AcceptRequestException(this.message);

  @override
  String toString() => 'AortemAuth0AcceptRequestException: $message';
}
