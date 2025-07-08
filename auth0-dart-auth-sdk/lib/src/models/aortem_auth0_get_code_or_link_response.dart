/// Represents the response from a request to initiate code or link-based authentication
/// flow with Auth0.
///
/// This response indicates whether the authentication request was successful, along
/// with an optional message providing more details about the result.
class AortemAuth0GetCodeOrLinkResponse {
  /// Indicates whether the authentication request was successful.
  final bool success;

  /// A message providing additional details about the result of the request.
  final String message;

  /// Constructs an [AortemAuth0GetCodeOrLinkResponse] with the given [success] status
  /// and [message].
  AortemAuth0GetCodeOrLinkResponse({
    required this.success,
    required this.message,
  });
}
