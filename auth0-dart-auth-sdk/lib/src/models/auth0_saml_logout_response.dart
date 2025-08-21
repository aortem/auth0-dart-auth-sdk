/// Represents the response containing the generated SAML logout URL.
///
/// This response includes the URL that the client can use to initiate the SAML
/// logout process with Auth0. It is typically used after making a request to
/// Auth0 to trigger a SAML logout.
class Auth0SamlLogoutResponse {
  /// The generated logout URL for Auth0 SAML.
  final String logoutUrl;

  /// Constructs an [Auth0SamlLogoutResponse] with the [logoutUrl].
  Auth0SamlLogoutResponse({required this.logoutUrl});

  /// Converts this instance into a JSON map, typically used for serialization.
  ///
  /// The returned map contains the [logout_url] key with the corresponding URL value.
  Map<String, dynamic> toJson() {
    return {'logout_url': logoutUrl};
  }

  @override
  String toString() {
    return 'Auth0SamlLogoutResponse(logoutUrl: $logoutUrl)';
  }
}
