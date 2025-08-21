import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../models/auth0_get_code_or_link_request.dart';
import '../models/auth0_get_code_or_link_response.dart';

/// Handles the process of sending a passwordless authentication code or link using Auth0.
///
/// This class provides functionality to trigger the sending of a passwordless authentication code
/// or a magic link to a user. It interacts with Auth0's passwordless authentication API endpoint.
///
/// Example usage:
/// ```dart
/// final authService = Auth0GetCodeOrLink(domain: 'your-auth0-domain');
/// final request = Auth0GetCodeOrLinkRequest(
///   clientId: 'your-client-id',
///   connection: 'email',
///   email: 'user@example.com',
/// );
/// try {
///   final response = await authService.sendCodeOrLink(request: request);
///   print(response.message);
/// } catch (e) {
///   print('Error: $e');
/// }
/// ```
class Auth0GetCodeOrLink {
  /// The Auth0 domain used for sending passwordless authentication codes or links.
  final String domain;

  /// Constructs an instance of [Auth0GetCodeOrLink].
  ///
  /// [domain] is the Auth0 domain to use for sending passwordless authentication codes or links.
  /// Throws an [ArgumentError] if the domain is empty or null.
  Auth0GetCodeOrLink({required this.domain}) {
    if (domain.trim().isEmpty) {
      throw ArgumentError('Auth0 domain must not be empty.');
    }
  }

  /// Sends a passwordless authentication code or magic link to a user.
  ///
  /// [request] contains the details for initiating the passwordless authentication flow,
  /// such as the connection type (email, SMS) and the user's email or phone number.
  ///
  /// Returns a [Auth0GetCodeOrLinkResponse] with the success message on a successful request.
  ///
  /// Throws an [Exception] if the request fails or if the response status is not 200.
  Future<Auth0GetCodeOrLinkResponse> sendCodeOrLink({
    required Auth0GetCodeOrLinkRequest request,
  }) async {
    final uri = Uri.https(domain, '/passwordless/start');

    final headers = {'Content-Type': 'application/json'};

    final body = json.encode(request.toJson());

    // Make the POST request to the Auth0 passwordless API
    final response = await http.post(uri, headers: headers, body: body);

    // Handle successful response
    if (response.statusCode == 200) {
      return Auth0GetCodeOrLinkResponse(
        success: true,
        message: 'Code or link successfully sent.',
      );
    } else {
      // Throw an exception if the response is not successful
      final errorBody = response.body.isNotEmpty
          ? response.body
          : 'No response body';
      throw Exception(
        'Failed to send code or link. Status code: ${response.statusCode}. Body: $errorBody',
      );
    }
  }
}
