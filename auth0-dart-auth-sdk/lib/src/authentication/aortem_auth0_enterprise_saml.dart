import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../exceptions/aortem_auth0_enterprise_saml_exception.dart';
import '../models/aortem_auth0_enterprise_saml_request_model.dart';
import '../models/aortem_auth0_enterprise_saml_response_model.dart';

/// Handles enterprise SAML authentication with Auth0.
///
/// This class manages the process of authenticating a user using the SAML authentication
/// flow for enterprise connections in Auth0. It sends a request to the Auth0 service,
/// processes the response, and handles any errors that occur during the authentication process.
///
/// Example usage:
/// ```dart
/// final authService = AortemAuth0EnterpriseSaml(
///   domain: 'your-auth0-domain',
/// );
/// try {
///   final response = await authService.authenticate(
///     connection: 'your-saml-connection',
///     samlRequest: 'your-saml-request',
///   );
///   print(response);
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class AortemAuth0EnterpriseSaml {
  /// The Auth0 domain to be used for authentication (e.g., 'example.auth0.com').
  final String domain;

  /// The HTTP client used to send requests. A new [http.Client] is used if not provided.
  final http.Client httpClient;

  /// The timeout duration for HTTP requests. Defaults to 10 seconds.
  final Duration timeout;

  /// Constructs an instance of [AortemAuth0EnterpriseSaml].
  ///
  /// [domain] is the Auth0 domain used for the SAML authentication request.
  /// [httpClient] is an optional parameter. If not provided, a new [http.Client] instance is used.
  /// [timeout] specifies the duration before a request times out. The default is 10 seconds.
  AortemAuth0EnterpriseSaml({
    required this.domain,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : httpClient = httpClient ?? http.Client();

  /// Initiates the SAML authentication flow.
  ///
  /// [connection] is the name of the connection (e.g., 'saml-connection').
  /// [samlRequest] is the base64-encoded SAML authentication request.
  /// [relayState] is an optional parameter used to pass state information to the redirect endpoint.
  ///
  /// Returns an [AortemAuth0EnterpriseSamlResponse] on successful authentication.
  ///
  /// Throws [AortemAuth0EnterpriseSamlException] if the request fails or the response is invalid.
  Future<AortemAuth0EnterpriseSamlResponse> authenticate({
    required String connection,
    required String samlRequest,
    String? relayState,
  }) async {
    final request = AortemAuth0EnterpriseSamlRequest(
      connection: connection,
      samlRequest: samlRequest,
      relayState: relayState,
    );

    try {
      // Make the POST request to the Auth0 SAML authentication endpoint
      final response = await httpClient
          .post(
            Uri.parse('https://$domain/samlp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(timeout);

      // Handle successful response
      if (response.statusCode == 200) {
        return AortemAuth0EnterpriseSamlResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        // Handle failed authentication
        throw AortemAuth0EnterpriseSamlException(
          message: 'SAML authentication failed',
          statusCode: response.statusCode,
          errorDetails: response.body,
        );
      }
    } on FormatException catch (e) {
      // Handle invalid response format from Auth0
      throw AortemAuth0EnterpriseSamlException(
        message: 'Invalid response format from Auth0',
        errorDetails: e.toString(),
      );
    } catch (e) {
      // Handle general errors such as network issues
      throw AortemAuth0EnterpriseSamlException(
        message: 'Failed to complete SAML authentication',
        errorDetails: e.toString(),
      );
    }
  }

  /// Closes the underlying HTTP client to free up resources.
  ///
  /// This method should be called when the [AortemAuth0EnterpriseSaml] instance
  /// is no longer needed, such as when the application is being closed or when switching clients.
  void close() {
    httpClient.close();
  }
}
