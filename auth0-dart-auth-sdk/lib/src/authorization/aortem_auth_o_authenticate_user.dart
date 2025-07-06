import 'dart:convert';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_authenticate_user_request_model.dart';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_authenticate_user_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles user authentication with Auth0.
///
/// This class facilitates the authentication of a user by sending a request to the
/// Auth0 authentication endpoint (`/oauth/token`) with the provided credentials and request parameters.
/// It processes the response and returns the result as an [AortemAuth0AuthenticateUserResponse] object.
///
/// Example usage:
/// ```dart
/// final authService = AortemAuth0AuthenticateUser(domain: 'your-auth0-domain');
/// final request = AortemAuth0AuthenticateUserRequest(clientId: 'your-client-id', clientSecret: 'your-client-secret');
/// try {
///   final response = await authService.authenticate(request: request);
///   print(response);
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class AortemAuth0AuthenticateUser {
  /// The Auth0 domain to be used for authentication (e.g., 'example.auth0.com').
  final String domain;

  /// Constructs an instance of [AortemAuth0AuthenticateUser].
  ///
  /// [domain] is the Auth0 domain used for the authentication request.
  AortemAuth0AuthenticateUser({required this.domain});

  /// Authenticates a user by sending a request to the Auth0 `/oauth/token` endpoint.
  ///
  /// [request] contains the authentication request details, such as client ID, client secret, and other parameters.
  /// The method sends the request to Auth0 and processes the response.
  ///
  /// Returns an [AortemAuth0AuthenticateUserResponse] on successful authentication.
  ///
  /// Throws an [Exception] if the authentication request fails or if the response indicates an error.
  Future<AortemAuth0AuthenticateUserResponse> authenticate({
    required AortemAuth0AuthenticateUserRequest request,
  }) async {
    final url = Uri.https(domain, '/oauth/token');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(request.toJson());

    // Make the POST request to Auth0's /oauth/token endpoint
    final response = await http.post(url, headers: headers, body: body);

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return AortemAuth0AuthenticateUserResponse.fromJson(responseBody);
    } else {
      // Throw an exception if authentication fails
      throw Exception('Authentication failed: ${response.body}');
    }
  }
}
