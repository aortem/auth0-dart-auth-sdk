import 'dart:convert';
import '../exceptions/auth0_list_authenticators_exception.dart';
import '../models/auth0_list_authenticators_model.dart';
import '../models/auth0_list_authenticators_request_model.dart';
import '../models/auth0_list_authenticators_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A client for listing multi-factor authentication (MFA) authenticators from Auth0.
///
/// This class provides functionality to retrieve a list of registered MFA
/// authenticators for a user from Auth0's API using an access token.
class Auth0ListAuthenticators {
  /// The access token used to authenticate requests to Auth0's API.
  ///
  /// Must be a valid JWT token with the required permissions to access
  /// the MFA authenticators endpoint.
  final String accessToken;

  /// The base URL of your Auth0 tenant (e.g., `https://my-tenant.auth0.com`).
  final String auth0Domain;
  final http.Client httpClient;

  /// Creates a new [Auth0ListAuthenticators] instance.
  ///
  /// [accessToken] must be a non-empty string representing a valid Auth0 access token.
  Auth0ListAuthenticators({
    required this.auth0Domain,
    required this.accessToken,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client() {
    if (auth0Domain.trim().isEmpty) {
      throw ArgumentError('Auth0 domain must not be empty.');
    }
    if (accessToken.trim().isEmpty) {
      throw ArgumentError('Access token is required.');
    }
  }

  /// Retrieves a list of registered MFA authenticators from Auth0.
  ///
  /// This method makes an authenticated request to Auth0's MFA authenticators
  /// endpoint to fetch all registered authenticators for the current user.
  ///
  /// [request] - The request parameters (currently unused in basic implementation,
  ///             but included for future extensibility)
  ///
  /// Returns a [Future] that completes with an [Auth0ListAuthenticatorsResponse]
  /// containing the list of authenticators if successful.
  ///
  /// Throws:
  /// - [ArgumentError] if the access token is empty
  /// - [Auth0ListAuthenticatorsException] if the API request fails
  /// - Other exceptions for network or JSON parsing errors
  Future<Auth0ListAuthenticatorsResponse> fetchAuthenticators(
    Auth0ListAuthenticatorsRequest request,
  ) async {
    // Check if the accessToken is provided
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token is required.');
    }

    // Build full URL dynamically from provided domain
    final url = _buildUri('/mfa/authenticators');

    try {
      // Send HTTP GET request to Auth0 endpoint with Authorization header
      final response = await httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseJson = json.decode(response.body);
        if (responseJson is List) {
          return Auth0ListAuthenticatorsResponse(
            authenticators: responseJson
                .cast<Map<String, dynamic>>()
                .map(Auth0Authenticator.fromJson)
                .toList(),
          );
        }
        if (responseJson is Map<String, dynamic>) {
          return Auth0ListAuthenticatorsResponse.fromJson(responseJson);
        }
        throw const FormatException('Unexpected response format');
      } else {
        // Handle error responses
        throw Auth0ListAuthenticatorsException(
          'Failed to retrieve authenticators: ${response.body}',
        );
      }
    } on Auth0ListAuthenticatorsException {
      rethrow;
    } catch (e) {
      // Handle unexpected errors, such as network issues or JSON parsing errors
      throw Auth0ListAuthenticatorsException('Error: ${e.toString()}');
    }
  }

  Uri _buildUri(String path) {
    final baseUri = Uri.parse(
      auth0Domain.contains('://') ? auth0Domain : 'https://$auth0Domain',
    );
    return baseUri.resolve(path);
  }
}
