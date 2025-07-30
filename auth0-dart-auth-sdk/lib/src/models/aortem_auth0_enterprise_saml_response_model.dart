import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_enterprise_saml_exception.dart';

/// Represents the result of the enterprise SAML login flow after Auth0 redirect.
///
/// This class parses and encapsulates the authentication response returned by Auth0
/// in the URL hash fragment after a successful SAML enterprise login.
/// It provides structured access to the tokens and parameters returned by Auth0.
///
/// Example usage:
/// ```dart
/// // From a redirect URL like:
/// // https://app.com/callback#access_token=xyz&id_token=abc&state=123
/// final response = AortemAuth0EnterpriseSamlResponse.fromHash(window.location.hash);
/// print('Access Token: ${response.accessToken}');
/// ```
class AortemAuth0EnterpriseSamlResponse {
  /// The OAuth 2.0 access token for API authorization
  final String? accessToken;

  /// The OpenID Connect ID token containing user information
  final String? idToken;

  /// The state parameter returned from the initial request (for CSRF protection)
  final String? state;

  /// The type of token returned (typically 'Bearer')
  final String? tokenType;

  /// Creates a response with the authentication tokens
  ///
  /// [accessToken]: OAuth access token for API calls
  /// [idToken]: JWT containing user identity information
  /// [state]: Original state value from the request
  /// [tokenType]: Type of the access token (usually 'Bearer')
  AortemAuth0EnterpriseSamlResponse({
    this.accessToken,
    this.idToken,
    this.state,
    this.tokenType,
  });

  /// Parses the URL hash fragment from Auth0's redirect response
  ///
  /// [urlHash]: The hash portion of the URL (e.g. "#access_token=...&id_token=...")
  /// Returns a structured [AortemAuth0EnterpriseSamlResponse] containing the tokens
  /// Throws [AortemAuth0EnterpriseSamlException] if the hash is empty
  ///
  /// Typical hash format:
  /// #access_token=ABCDEF&token_type=Bearer&id_token=GHIJKL&state=123456
  factory AortemAuth0EnterpriseSamlResponse.fromHash(String urlHash) {
    if (urlHash.isEmpty) {
      throw AortemAuth0EnterpriseSamlException(
        message: 'URL hash is empty, no Auth0 response found',
      );
    }

    // Remove the leading '#' and parse the query parameters
    final params = Uri.splitQueryString(urlHash.replaceFirst('#', ''));

    return AortemAuth0EnterpriseSamlResponse(
      accessToken: params['access_token'],
      idToken: params['id_token'],
      tokenType: params['token_type'],
      state: params['state'],
    );
  }

  /// Indicates whether the response contains valid authentication tokens
  bool get isSuccessful => accessToken != null && idToken != null;
}
