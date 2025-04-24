import 'dart:core';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_oidc_logout_request_model.dart';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_oidc_logout_response_model.dart';

/// Provides OpenID Connect (OIDC) compliant logout functionality for Auth0.
///
/// This class handles the generation of logout URLs according to the OIDC specification,
/// allowing for both local session termination and federated logout from identity providers.
///
/// Example usage:
/// ```dart
/// final logoutService = AortemAuth0OidcLogout(auth0Domain: 'your-domain.auth0.com');
/// final request = AortemAuth0OidcLogoutRequest(
///   clientId: 'your_client_id',
///   idTokenHint: 'current_id_token',
///   postLogoutRedirectUri: 'https://your-app.com/logout-callback',
///   state: 'optional_state_value'
/// );
///
/// final response = logoutService.generateLogoutUrl(request);
/// // Redirect user to response.logoutUrl
/// ```
class AortemAuth0OidcLogout {
  /// The Auth0 domain used for logout operations.
  ///
  /// This should match the domain configured in your Auth0 tenant (e.g., 'your-tenant.auth0.com').
  /// Must be a non-empty string.
  final String auth0Domain;

  /// Creates an instance of the OIDC logout service.
  ///
  /// [auth0Domain] is required and must be a non-empty string representing your Auth0 tenant domain.
  ///
  /// Throws:
  /// - [ArgumentError] if [auth0Domain] is empty or contains only whitespace
  AortemAuth0OidcLogout({required this.auth0Domain}) {
    if (auth0Domain.trim().isEmpty) {
      throw ArgumentError('auth0Domain is required and cannot be empty.');
    }
  }

  /// Generates an OIDC-compliant logout URL for Auth0.
  ///
  /// Constructs a logout URL according to the OpenID Connect Session Management specification.
  /// The URL will terminate both the local session and (when possible) the session at the identity provider.
  ///
  /// [request] must contain at minimum the clientId. Other parameters are optional but recommended:
  /// - idTokenHint: Improves security and ensures proper logout from identity providers
  /// - postLogoutRedirectUri: Where to redirect after logout completes
  /// - state: Optional security parameter for CSRF protection
  ///
  /// Returns:
  /// - [AortemAuth0OidcLogoutResponse] containing the constructed logout URL
  ///
  /// Example URL structure:
  /// `https://[auth0Domain]/v2/logout?client_id=[clientId]&id_token_hint=[token]&post_logout_redirect_uri=[uri]&state=[state]`
  AortemAuth0OidcLogoutResponse generateLogoutUrl(
    AortemAuth0OidcLogoutRequest request,
  ) {
    final queryParams = <String, String>{'client_id': request.clientId};

    if (request.idTokenHint != null && request.idTokenHint!.isNotEmpty) {
      queryParams['id_token_hint'] = request.idTokenHint!;
    }

    if (request.postLogoutRedirectUri != null &&
        request.postLogoutRedirectUri!.isNotEmpty) {
      queryParams['post_logout_redirect_uri'] = request.postLogoutRedirectUri!;
    }

    if (request.state != null && request.state!.isNotEmpty) {
      queryParams['state'] = request.state!;
    }

    final queryString = Uri(queryParameters: queryParams).query;
    final logoutUrl = 'https://$auth0Domain/v2/logout?$queryString';

    return AortemAuth0OidcLogoutResponse(logoutUrl: logoutUrl);
  }
}
