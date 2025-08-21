import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:auth0_dart_auth_sdk/src/exceptions/auth0_user_profile_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/auth0_user_profile_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/auth0_user_profile_response_model.dart';

/// A class to interact with the Auth0 UserInfo endpoint to retrieve user profile information.
class Auth0UserProfile {
  /// Retrieves the user's profile information from Auth0.
  ///
  /// This function makes a request to the `/userinfo` endpoint using the provided access token.
  ///
  /// [request] contains the access token required for the request.
  /// [auth0Domain] is the Auth0 domain (e.g., `your-domain.auth0.com`).
  ///
  /// Throws an [ArgumentError] if the access token is missing or empty.
  /// Throws a [Auth0UserProfileException] if the API returns an error or if there's a problem parsing the response.
  Future<Auth0UserProfileResponse> auth0UserProfile(
    Auth0UserProfileRequest request,
    String auth0Domain, // The Auth0 domain (e.g., 'your-domain.auth0.com')
  ) async {
    final url = Uri.https(auth0Domain, '/userinfo');

    // Ensure that accessToken is provided
    if (request.accessToken.isEmpty) {
      throw ArgumentError('Access token is required');
    }

    // Send GET request to the /userinfo endpoint with Authorization header
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${request.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      // Successfully retrieved user profile, parse the response
      try {
        final responseBody = json.decode(response.body);
        return Auth0UserProfileResponse.fromJson(responseBody);
      } catch (e) {
        throw Auth0UserProfileException('Error parsing response: $e');
      }
    } else {
      // Handle error responses
      final errorMessage = _getErrorMessage(response);
      throw Auth0UserProfileException(errorMessage);
    }
  }

  /// Helper function to extract the error message from the API response.
  ///
  /// This function decodes the response body and attempts to retrieve the error description
  /// provided by Auth0. If an error occurs while decoding or if no error description is available,
  /// a default error message is returned.
  ///
  /// [response] is the HTTP response received from the Auth0 `/userinfo` endpoint.
  ///
  /// Returns a string representing the error message.
  String _getErrorMessage(http.Response response) {
    try {
      final errorResponse = json.decode(response.body);
      return errorResponse['error_description'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error with status code: ${response.statusCode}';
    }
  }
}
