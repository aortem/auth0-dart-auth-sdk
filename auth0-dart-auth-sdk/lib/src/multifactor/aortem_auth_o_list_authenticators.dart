import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth_o_list_authenticators_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_list_authenticators_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_list_authenticators_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A client for listing multi-factor authentication (MFA) authenticators from Auth0.
///
/// This class provides functionality to retrieve a list of registered MFA
/// authenticators for a user from Auth0's API using an access token.
class AortemAuth0ListAuthenticators {
  /// The access token used to authenticate requests to Auth0's API.
  ///
  /// Must be a valid JWT token with the required permissions to access
  /// the MFA authenticators endpoint.
  final String accessToken;

  /// Creates a new [AortemAuth0ListAuthenticators] instance.
  ///
  /// [accessToken] must be a non-empty string representing a valid Auth0 access token.
  AortemAuth0ListAuthenticators(this.accessToken);

  /// Retrieves a list of registered MFA authenticators from Auth0.
  ///
  /// This method makes an authenticated request to Auth0's MFA authenticators
  /// endpoint to fetch all registered authenticators for the current user.
  ///
  /// [request] - The request parameters (currently unused in basic implementation,
  ///             but included for future extensibility)
  ///
  /// Returns a [Future] that completes with an [AortemAuth0ListAuthenticatorsResponse]
  /// containing the list of authenticators if successful.
  ///
  /// Throws:
  /// - [ArgumentError] if the access token is empty
  /// - [AortemAuth0ListAuthenticatorsException] if the API request fails
  /// - Other exceptions for network or JSON parsing errors
  Future<AortemAuth0ListAuthenticatorsResponse> fetchAuthenticators(
    AortemAuth0ListAuthenticatorsRequest request,
  ) async {
    // Check if the accessToken is provided
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token is required.');
    }

    // Construct the API URL for Auth0 MFA authenticators
    final url = Uri.parse('https://YOUR_AUTH0_DOMAIN/mfa/authenticators');

    try {
      // Send HTTP GET request to Auth0 endpoint with Authorization header
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseJson = json.decode(response.body);
        return AortemAuth0ListAuthenticatorsResponse.fromJson(responseJson);
      } else {
        // Handle error responses
        throw AortemAuth0ListAuthenticatorsException(
          'Failed to retrieve authenticators: ${response.body}',
        );
      }
    } catch (e) {
      // Handle unexpected errors, such as network issues or JSON parsing errors
      throw AortemAuth0ListAuthenticatorsException('Error: ${e.toString()}');
    }
  }
}
