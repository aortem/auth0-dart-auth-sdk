import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_enterprise_saml_request_model.dart';

/// Main service class to handle Auth0 enterprise SAML authentication flows.
///
/// This class provides the core functionality for building enterprise SAML
/// authentication URLs while remaining platform-agnostic (no direct browser
/// dependencies). It constructs the proper `/authorize` URL that callers
/// can use to initiate the SAML login flow.
///
/// Example usage:
/// ```dart
/// final auth0 = AortemAuth0EnterpriseSaml(
///   domain: 'your-domain.auth0.com',
///   clientId: 'your_client_id',
/// );
///
/// final request = AortemAuth0EnterpriseSamlRequest(
///   connection: 'saml-enterprise-connection',
///   redirectUri: 'https://yourapp.com/callback',
/// );
///
/// final authUrl = auth0.buildAuthorizeUrl(request);
/// // Redirect user to authUrl
/// ```
class AortemAuth0EnterpriseSaml {
  /// The Auth0 domain (e.g., 'your-tenant.auth0.com')
  final String domain;

  /// The Auth0 application client ID
  final String clientId;

  /// Creates an instance configured for your Auth0 application
  ///
  /// [domain]: Your Auth0 domain (e.g., 'your-tenant.auth0.com')
  /// [clientId]: The client ID of your Auth0 application
  AortemAuth0EnterpriseSaml({required this.domain, required this.clientId});

  /// Constructs the authorization URL for initiating SAML enterprise login
  ///
  /// [request]: Configured request parameters including connection and redirect URI
  /// Returns a fully-formed Uri that can be used to redirect users to Auth0
  ///
  /// The generated URL will look like:
  /// `https://domain/authorize?response_type=token&client_id=...&redirect_uri=...`
  Uri buildAuthorizeUrl(AortemAuth0EnterpriseSamlRequest request) {
    final params = request.toQueryParams(clientId);
    return Uri.https(domain, '/authorize', params);
  }

  /// Helper method to validate if the current configuration appears valid
  bool get isConfigurationValid =>
      domain.isNotEmpty && clientId.isNotEmpty && domain.endsWith('.auth0.com');
}
