import 'package:auth0_dart_auth_sdk/src/exceptions/auth0_enterprise_saml_exception.dart';

/// Represents the parameters needed to start an enterprise SAML login flow.
///
/// This class encapsulates all the necessary parameters required to initiate
/// a SAML-based authentication flow with Auth0 for enterprise connections.
/// It's primarily used to construct the `/authorize` URL for browser-based authentication.
///
/// Example usage:
/// ```dart
/// final request = Auth0EnterpriseSamlRequest(
///   connection: 'saml-enterprise-connection',
///   redirectUri: 'https://myapp.com/callback',
///   state: 'some-state-value',
/// );
/// ```
class Auth0EnterpriseSamlRequest {
  /// The Auth0 connection name for the SAML enterprise identity provider
  final String connection;

  /// The URI to redirect to after authentication is complete
  final String redirectUri;

  /// Optional state parameter for CSRF protection and state maintenance
  final String? state;

  /// The response type expected from the authentication flow (defaults to 'token')
  final String responseType;

  /// Creates a new request for enterprise SAML authentication
  ///
  /// [connection]: The name of the SAML enterprise connection configured in Auth0
  /// [redirectUri]: The callback URI where the user will be redirected after auth
  /// [state]: Optional state value for security and session tracking
  /// [responseType]: The OAuth 2.0 response type (defaults to 'token' for implicit flow)
  ///
  /// Throws [Auth0EnterpriseSamlException] if connection or redirectUri are empty
  Auth0EnterpriseSamlRequest({
    required this.connection,
    required this.redirectUri,
    this.state,
    this.responseType = 'token',
  }) {
    if (connection.trim().isEmpty || redirectUri.trim().isEmpty) {
      throw Auth0EnterpriseSamlException(
        message: 'Connection and redirectUri cannot be empty',
      );
    }
  }

  /// Converts the request parameters to a map of query parameters
  ///
  /// [clientId]: The Auth0 application client ID
  /// Returns a Map containing all parameters as URL query parameters
  Map<String, String> toQueryParams(String clientId) {
    final params = <String, String>{
      'response_type': responseType,
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'connection': connection,
    };
    if (state != null) params['state'] = state!;
    return params;
  }
}
