import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/models/auth0_authenticate_user_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/auth0_authenticate_user_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles user authentication with Auth0.
///
/// This class facilitates the authentication of a user by sending a request to the
/// Auth0 authentication endpoint (`/oauth/token`) with the provided credentials and request parameters.
/// It processes the response and returns the result as an [Auth0AuthenticateUserResponse] object.
///
/// Example usage:
/// ```dart
/// final authService = Auth0AuthenticateUser(domain: 'your-auth0-domain');
/// final request = Auth0AuthenticateUserRequest(clientId: 'your-client-id', clientSecret: 'your-client-secret');
/// try {
///   final response = await authService.authenticate(request: request);
///   print(response);
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class Auth0AuthenticateUser {
  /// The Auth0 domain to be used for authentication (e.g., 'example.auth0.com').
  final String domain;

  /// Constructs an instance of [Auth0AuthenticateUser].
  ///
  /// [domain] is the Auth0 domain used for the authentication request.
  Auth0AuthenticateUser({required this.domain});

  /// Authenticates a user by sending a request to the Auth0 `/oauth/token` endpoint.
  ///
  /// [request] contains the authentication request details, such as client ID, client secret, and other parameters.
  /// The method sends the request to Auth0 and processes the response.
  ///
  /// Returns an [Auth0AuthenticateUserResponse] on successful authentication.
  ///
  /// Throws an [Exception] if the authentication request fails or if the response indicates an error.
  Future<Auth0AuthenticateUserResponse> authenticate({
    required Auth0AuthenticateUserRequest request,
  }) async {
    final url = Uri.https(domain, '/oauth/token');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(request.toJson());

    // Make the POST request to Auth0's /oauth/token endpoint
    final response = await http.post(url, headers: headers, body: body);

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return Auth0AuthenticateUserResponse.fromJson(responseBody);
    } else {
      // Throw an exception if authentication fails
      throw Exception('Authentication failed: ${response.body}');
    }
  }
}
