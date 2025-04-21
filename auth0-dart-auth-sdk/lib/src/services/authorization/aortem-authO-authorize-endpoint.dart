import '../../models/aortem-auth0-authorize-endpoint_request_model.dart';
import '../../models/aortem-auth0-authorize-endpoint_response_model.dart';

/// A service class for generating Auth0 `/authorize` endpoint URLs.
///
/// This class provides a method to construct the full authorization
/// URL required to initiate an Auth0 OAuth2/OIDC flow.
class AortemAuth0AuthorizeEndpoint {
  final Uri auth0DomainUri;

  /// Creates an instance of [AortemAuth0AuthorizeEndpoint].
  ///
  /// [auth0DomainUri] must be a valid URI pointing to the Auth0 domain,
  /// such as `https://your-domain.auth0.com`.
  AortemAuth0AuthorizeEndpoint({required this.auth0DomainUri}) {
    if (auth0DomainUri.toString().isEmpty) {
      throw ArgumentError('auth0DomainUri must not be empty.');
    }
  }

  /// Generates the `/authorize` endpoint URL using the given [request].
  ///
  /// Throws an [ArgumentError] if required fields are missing in the request.
  ///
  /// Returns an [AortemAuth0AuthorizeEndpointResponse] with the constructed URL.
  AortemAuth0AuthorizeEndpointResponse generateAuthorizeUrl({
    required AortemAuth0AuthorizeEndpointRequest request,
  }) {
    if (request.clientId.isEmpty ||
        request.redirectUri.toString().isEmpty ||
        request.responseType.isEmpty) {
      throw ArgumentError(
        'clientId, redirectUri, and responseType must not be empty.',
      );
    }

    final authorizeUri = auth0DomainUri.resolve('/authorize');
    final params = request.toQueryParameters();

    final fullUrl = Uri(
      scheme: authorizeUri.scheme,
      host: authorizeUri.host,
      port: authorizeUri.hasPort ? authorizeUri.port : null,
      path: authorizeUri.path,
      queryParameters: params,
    );

    return AortemAuth0AuthorizeEndpointResponse(fullUrl);
  }
}
