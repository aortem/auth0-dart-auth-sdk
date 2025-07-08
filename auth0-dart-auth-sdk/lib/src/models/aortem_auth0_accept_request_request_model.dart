/// Represents a request to accept a passwordless login request via Auth0's magic link.
///
/// This model contains the required parameters to accept a passwordless authentication
/// request using Auth0's API.
class AortemAuth0AcceptRequestRequest {
  /// The client ID of the Auth0 application.
  final String clientId;

  /// The ticket received from the passwordless authentication request.
  ///
  /// This is typically obtained from the magic link sent to the user's email.
  final String ticket;

  /// Creates a new [AortemAuth0AcceptRequestRequest] instance.
  ///
  /// Both [clientId] and [ticket] must be non-empty strings.
  AortemAuth0AcceptRequestRequest({
    required this.clientId,
    required this.ticket,
  });
}
