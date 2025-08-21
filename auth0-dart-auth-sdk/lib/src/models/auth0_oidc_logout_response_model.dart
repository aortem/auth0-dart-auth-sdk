/// Represents the response containing the generated OIDC logout URL.
class Auth0OidcLogoutResponse {
  /// The generated logout URL for Auth0 OIDC.
  final String logoutUrl;

  ///constructure
  Auth0OidcLogoutResponse({required this.logoutUrl});

  /// Converts this instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {'logout_url': logoutUrl};
  }

  @override
  String toString() {
    return 'Auth0OidcLogoutResponse(logoutUrl: $logoutUrl)';
  }
}
