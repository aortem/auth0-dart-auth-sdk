import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_dynamic_application_client_registration_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_dynamic_application_client_registration_response_model.dart';

/// A utility class to build an Auth0 authorization URL.
class AortemAuth0AuthorizeApplicationBuilder {
  /// Constructs the authorization URL based on the provided domain and request parameters.
  static AortemAuth0AuthorizeApplicationResponse build({
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
