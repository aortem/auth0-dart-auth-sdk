import 'dart:convert';
import 'dart:async';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_signup_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_signup_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_signup_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for handling user signups via Auth0.
///
/// This class provides a method for signing up a new user using Auth0's
/// database connection signup API. It takes user details and sends a signup
/// request to Auth0. The method returns a response containing information
/// about the success or failure of the signup process.
///
/// Example usage:
/// ```dart
/// final signupService = AortemAuth0Signup();
/// final request = AortemAuth0SignupRequest(
///   clientId: 'your-client-id',
///   email: 'user@example.com',
///   password: 'user-password',
///   connection: 'your-connection-name',
/// );
/// try {
///   final response = await signupService.aortemAuth0Signup(request, 'your-domain.auth0.com');
///   print('Signup successful: ${response.userId}');
/// } catch (e) {
///   print('Signup failed: $e');
/// }
/// ```
class AortemAuth0Signup {
  /// Signs up a new user via Auth0's database connection signup API.
  ///
  /// [request] contains the user's signup information, such as email, password, and connection.
  /// [auth0Domain] is the Auth0 domain, typically in the format 'your-domain.auth0.com'.
  ///
  /// Returns an [AortemAuth0SignupResponse] containing the result of the signup process.
  ///
  /// Throws an [AortemAuth0SignupException] if an error occurs during the signup process or if
  /// the response from Auth0 cannot be parsed correctly.
  Future<AortemAuth0SignupResponse> aortemAuth0Signup(
    AortemAuth0SignupRequest request,
    String auth0Domain, // The Auth0 domain, e.g., 'your-domain.auth0.com'
  ) async {
    final url = Uri.https(auth0Domain, '/dbconnections/signup');

    // Send POST request to Auth0
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    // Handle successful response
    if (response.statusCode == 200) {
      try {
        final responseBody = json.decode(response.body);
        return AortemAuth0SignupResponse.fromJson(responseBody);
      } catch (e) {
        throw AortemAuth0SignupException('Error parsing response: $e');
      }
    } else {
      // Handle error responses and extract error details
      final errorMessage = _getErrorMessage(response);
      throw AortemAuth0SignupException(errorMessage);
    }
  }

  /// Helper function to extract the error message from the API response.
  ///
  /// This function attempts to parse the response body and extract a detailed
  /// error message. If parsing fails, it falls back to a generic error message
  /// containing the status code.
  ///
  /// [response] is the HTTP response returned from the Auth0 API.
  ///
  /// Returns a string containing the error message.
  String _getErrorMessage(http.Response response) {
    try {
      final errorResponse = json.decode(response.body);
      return errorResponse['error_description'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error with status code: ${response.statusCode}';
    }
  }
}
