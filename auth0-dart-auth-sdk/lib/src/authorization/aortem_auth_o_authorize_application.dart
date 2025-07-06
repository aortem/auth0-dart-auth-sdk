import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_authorize_application_request_model.dart';

import '../models/aortem_auth0_authorize_application_response_model.dart';

/// A service class responsible for building Auth0 Authorization URLs
/// for initiating OAuth2/OIDC login flows.
///
/// This service uses Auth0’s `authorize` endpoint to construct a URL
/// with all necessary query parameters such as `client_id`, `redirect_uri`,
/// `response_type`, and optional parameters like `scope`, `state`, `audience`, etc.
class AortemAuth0AuthorizeApplicationService {
  /// Builds an authorization URL for the Auth0 `authorize` endpoint using
  /// the provided domain and request parameters.
  ///
  /// This method validates the required fields and throws an [ArgumentError]
  /// if any required field is missing.
  ///
  /// Returns an [AortemAuth0AuthorizeApplicationResponse] containing the constructed URL.
  ///
  /// Example:
  /// ```dart
  /// final response = AortemAuth0AuthorizeApplicationService().buildAuthorizationUrl(
  ///   auth0DomainUri: Uri.parse('https://your-tenant.auth0.com'),
  ///   request: AortemAuth0AuthorizeApplicationRequest(
  ///     clientId: 'abc123',
  ///     redirectUri: Uri.parse('https://example.com/callback'),
  ///     responseType: 'code',
  ///     scope: 'openid profile',
  ///     state: 'xyz',
  ///   ),
  /// );
  ///
  /// print(response.url); // Final redirect URL to Auth0
  /// ```
  AortemAuth0AuthorizeApplicationResponse buildAuthorizationUrl({
    required Uri auth0DomainUri,
    required AortemAuth0AuthorizeApplicationRequest request,
  }) {
    if (auth0DomainUri.toString().isEmpty) {
      throw ArgumentError('Auth0 domain URI must not be empty.');
    }
    if (request.clientId.isEmpty) {
      throw ArgumentError('Client ID must not be empty.');
    }
    if (request.redirectUri.toString().isEmpty) {
      throw ArgumentError('Redirect URI must not be empty.');
    }
    if (request.responseType.isEmpty) {
      throw ArgumentError('Response type must not be empty.');
    }

    final queryParams = {
      'client_id': request.clientId,
      'redirect_uri': request.redirectUri.toString(),
      'response_type': request.responseType,
      if (request.scope != null) 'scope': request.scope!,
      if (request.state != null) 'state': request.state!,
      if (request.audience != null) 'audience': request.audience!,
      if (request.connection != null) 'connection': request.connection!,
      if (request.prompt != null) 'prompt': request.prompt!,
    };

    final uri = auth0DomainUri.replace(
      path: '/authorize',
      queryParameters: queryParams,
    );

    return AortemAuth0AuthorizeApplicationResponse(url: uri);
  }
}
