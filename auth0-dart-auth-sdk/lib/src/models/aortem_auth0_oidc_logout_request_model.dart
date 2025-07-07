/// Represents the request payload for OIDC logout via Auth0.
class AortemAuth0OidcLogoutRequest {
  /// The client identifier for the Auth0 application.
  final String clientId;

  /// Optional: The ID token previously issued to the user (used as a hint to Auth0).
  final String? idTokenHint;

  /// Optional: The URL to which the user will be redirected after logout.
  final String? postLogoutRedirectUri;

  /// Optional: Opaque value used to maintain state between the logout request and the callback.
  final String? state;

  ///Constructure
  AortemAuth0OidcLogoutRequest({
    required this.clientId,
    this.idTokenHint,
    this.postLogoutRedirectUri,
    this.state,
  }) {
    if (clientId.trim().isEmpty) {
      throw ArgumentError('clientId is required and cannot be empty.');
    }
  }

  /// Converts this request into a map of query parameters.
  Map<String, String> toQueryParams() {
    final params = <String, String>{
      'client_id': clientId,
    };
    if (idTokenHint != null && idTokenHint!.trim().isNotEmpty) {
      params['id_token_hint'] = idTokenHint!;
    }
    if (postLogoutRedirectUri != null &&
        postLogoutRedirectUri!.trim().isNotEmpty) {
      params['post_logout_redirect_uri'] = postLogoutRedirectUri!;
    }
    if (state != null && state!.trim().isNotEmpty) {
      params['state'] = state!;
    }
    return params;
  }
}
