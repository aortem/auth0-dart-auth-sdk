// Importing the request model for the Auth0 authorize endpoint
import '../models/auth0_authorize_endpoint_request_model.dart';
// Importing the response model for the Auth0 authorize endpoint
import '../models/auth0_authorize_endpoint_response_model.dart';

/// A service class for generating Auth0 `/authorize` endpoint URLs.
///
/// This class provides a method to construct the full authorization
/// URL required to initiate an Auth0 OAuth2/OIDC flow.
class Auth0AuthorizeEndpoint {
  /// The base URI of the Auth0 domain (e.g., 'https://your-domain.auth0.com')
  /// Used as the foundation for building the authorize endpoint URL
  final Uri auth0DomainUri;

  /// Creates an instance of [Auth0AuthorizeEndpoint].
  ///
  /// Parameters:
  /// - [auth0DomainUri]: The base URI of your Auth0 domain
  ///   Must be a valid URI pointing to the Auth0 domain
  ///
  /// Throws:
  /// - [ArgumentError] if the provided auth0DomainUri is empty
  Auth0AuthorizeEndpoint({required this.auth0DomainUri}) {
    // Validate that the provided auth0DomainUri is not empty
    if (auth0DomainUri.toString().isEmpty) {
      throw ArgumentError('auth0DomainUri must not be empty.');
    }
  }

  /// Generates the `/authorize` endpoint URL using the given [request].
  ///
  /// Parameters:
  /// - [request]: The authorization request parameters
  ///   Must contain valid clientId, redirectUri, and responseType
  ///
  /// Returns:
  /// - [Auth0AuthorizeEndpointResponse] containing the fully constructed
  ///   authorization URL with all query parameters
  ///
  /// Throws:
  /// - [ArgumentError] if required fields are missing in the request
  Auth0AuthorizeEndpointResponse generateAuthorizeUrl({
    required Auth0AuthorizeEndpointRequest request,
  }) {
    // Validate required fields in the request
    if (request.clientId.isEmpty ||
        request.redirectUri.toString().isEmpty ||
        request.responseType.isEmpty) {
      throw ArgumentError(
        'clientId, redirectUri, and responseType must not be empty.',
      );
    }

    // Construct the base authorize URI by resolving '/authorize' path
    final authorizeUri = auth0DomainUri.resolve('/authorize');

    // Convert the request parameters to a query parameters map
    final params = request.toQueryParameters();

    // Build the complete URI with all components and query parameters
    final fullUrl = Uri(
      scheme: authorizeUri.scheme, // Preserve original scheme (https)
      host: authorizeUri.host, // Preserve original host
      port: authorizeUri.hasPort
          ? authorizeUri.port
          : null, // Preserve port if exists
      path: authorizeUri.path, // The '/authorize' path
      queryParameters: params, // All OAuth2/OIDC parameters
    );

    // Return the response object containing the fully constructed URL
    return Auth0AuthorizeEndpointResponse(fullUrl);
  }
}
