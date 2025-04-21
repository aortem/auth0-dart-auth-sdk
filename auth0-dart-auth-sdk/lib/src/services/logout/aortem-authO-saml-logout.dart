// lib/src/auth0/saml/aortem_auth0_saml_logout.dart

import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_saml_logout_request.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_saml_logout_response.dart';

/// A service class that handles SAML logout functionality through Auth0.
///
/// This class provides methods to generate SAML logout URLs using Auth0's SAML protocol.
/// It requires an Auth0 domain to be initialized and validates that the domain is not empty.
///
/// Example usage:
/// ```dart
/// final logout = AortemAuth0SamlLogout(domain: 'your-tenant.auth0.com');
/// final request = AortemAuth0SamlLogoutRequest(
///   clientId: 'your-client-id',
///   returnTo: 'https://your-app.com',
///   federated: true
/// );
/// final response = logout.buildLogoutUrl(request);
/// // Use response.logoutUrl to redirect user for logout
class AortemAuth0SamlLogout {
  /// The domain name of the Auth0 tenant
  final String domain;

  /// Constructor that initializes the SAML logout service with an Auth0 domain
  ///
  /// Throws [ArgumentError] if the domain is empty
  AortemAuth0SamlLogout({required this.domain}) {
    if (domain.trim().isEmpty) {
      throw ArgumentError('Auth0 domain must not be empty.');
    }
  }

  /// Builds a SAML logout URL using the provided request parameters
  ///
  /// Takes an [AortemAuth0SamlLogoutRequest] and returns an [AortemAuth0SamlLogoutResponse]
  /// containing the generated logout URL
  AortemAuth0SamlLogoutResponse buildLogoutUrl(
      AortemAuth0SamlLogoutRequest request) {
    final uri = Uri.https(domain, '/samlp/logout', request.toQueryParams());
    return AortemAuth0SamlLogoutResponse(logoutUrl: uri.toString());
  }
}
