import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../exceptions/aortem_auth0_change_password_exception.dart';
import '../models/aortem_auth0_change_password_request_model.dart';
import '../models/aortem_auth0_change_password_response_model.dart';

/// A service class for handling password change requests with Auth0.
///
/// This class provides functionality to initiate a password change flow
/// by sending a request to Auth0's password change endpoint, which typically
/// triggers a password reset email to the user.
class AortemAuth0ChangePassword {
  /// Initiates a password change request with Auth0.
  ///
  /// This method sends a request to Auth0's password change endpoint
  /// (`/dbconnections/change_password`) to trigger a password reset email.
  ///
  /// [request]: The password change request containing client ID, email, and connection details.
  /// [auth0Domain]: The Auth0 domain (e.g., 'your-domain.auth0.com').
  ///
  /// Returns a [Future<AortemAuth0ChangePasswordResponse>] containing Auth0's response.
  ///
  /// Throws [AortemAuth0ChangePasswordException] if:
  /// - The request fails (non-200 status code)
  /// - The response cannot be parsed
  Future<AortemAuth0ChangePasswordResponse> aortemAuth0ChangePassword(
    AortemAuth0ChangePasswordRequest request,
    String auth0Domain,
  ) async {
    final url = Uri.https(auth0Domain, '/dbconnections/change_password');

    // Send POST request to Auth0
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      // Successfully sent password change email, parse the response
      try {
        if (response.headers['content-type']?.contains('application/json') ==
            true) {
          final responseBody = json.decode(response.body);
          return AortemAuth0ChangePasswordResponse.fromJson(responseBody);
        } else {
          return AortemAuth0ChangePasswordResponse(message: response.body);
        }
      } catch (e) {
        throw AortemAuth0ChangePasswordException('Error parsing response: $e');
      }
    } else {
      // Handle error responses
      final errorMessage = _getErrorMessage(response);
      throw AortemAuth0ChangePasswordException(errorMessage);
    }
  }

  /// Extracts an error message from an unsuccessful API response.
  ///
  /// Attempts to parse the error response body to extract a meaningful
  /// error message. Falls back to a generic status code message if parsing fails.
  ///
  /// [response]: The HTTP response from the failed request.
  /// Returns a formatted error message string.
  String _getErrorMessage(http.Response response) {
    try {
      final errorResponse = json.decode(response.body);
      return errorResponse['error_description'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error with status code: ${response.statusCode}';
    }
  }
}
