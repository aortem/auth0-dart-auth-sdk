import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_social_login_response.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../exceptions/aortem_auth_o_social_login_exceptions.dart';
import '../models/aortem_auth_o_social_login_request.dart';

/// Handles social login authentication with Auth0.
///
/// This class facilitates the process of authenticating a user using a social provider's
/// access token (e.g., Google, Facebook, etc.) via the Auth0 OAuth2 flow. It sends a request
/// to the Auth0 authentication endpoint, processes the response, and handles any errors that may
/// occur during the login process.
///
/// Example usage:
/// ```dart
/// final authService = AortemAuth0SocialLogin(
///   domain: 'your-auth0-domain',
///   clientId: 'your-client-id',
/// );
/// try {
///   final response = await authService.authenticate(
///     socialAccessToken: 'social-access-token',
///     connection: 'social-connection',
///   );
///   print(response);
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class AortemAuth0SocialLogin {
  /// The Auth0 domain to be used for authentication (e.g., 'example.auth0.com').
  final String domain;

  /// The Auth0 client ID associated with the application.
  final String clientId;

  /// The HTTP client used to send requests. A new [http.Client] is used if not provided.
  final http.Client httpClient;

  /// The timeout duration for HTTP requests. Defaults to 10 seconds.
  final Duration timeout;

  /// Constructs an instance of [AortemAuth0SocialLogin].
  ///
  /// [domain] is the Auth0 domain used for social login requests.
  /// [clientId] is the Auth0 client ID for the application.
  /// [httpClient] is an optional parameter. If not provided, a new [http.Client] instance is used.
  /// [timeout] specifies the duration before a request times out. The default is 10 seconds.
  AortemAuth0SocialLogin({
    required this.domain,
    required this.clientId,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : httpClient = httpClient ?? http.Client();

  /// Authenticates a user using a social provider's access token.
  ///
  /// [socialAccessToken] is the access token from the social provider (e.g., Google, Facebook).
  /// [connection] is the name of the social connection in Auth0 (e.g., 'google', 'facebook').
  /// [scope] is an optional parameter specifying the scope of the requested access.
  /// [audience] is an optional parameter specifying the target audience for the authentication.
  ///
  /// Returns an [AortemAuth0SocialLoginResponse] upon successful authentication.
  ///
  /// Throws [AortemAuth0SocialLoginException] if the request fails, the response is invalid,
  /// or any other errors occur during the process.
  Future<AortemAuth0SocialLoginResponse> authenticate({
    required String socialAccessToken,
    required String connection,
    String? scope,
    String? audience,
  }) async {
    final request = AortemAuth0SocialLoginRequest(
      socialAccessToken: socialAccessToken,
      connection: connection,
      clientId: clientId,
      scope: scope,
      audience: audience,
    );

    try {
      // Make the POST request to the Auth0 OAuth endpoint for social login
      final response = await httpClient
          .post(
            Uri.parse('https://$domain/oauth/access_token'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(timeout);

      // Handle successful response
      if (response.statusCode == 200) {
        return AortemAuth0SocialLoginResponse.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // Handle failed authentication
        throw AortemAuth0SocialLoginException(
          message: 'Social login failed',
          statusCode: response.statusCode,
          errorDetails: response.body,
        );
      }
    } on FormatException catch (e) {
      // Handle invalid response format from Auth0
      throw AortemAuth0SocialLoginException(
        message: 'Invalid response format from Auth0',
        errorDetails: e.toString(),
      );
    } catch (e) {
      // Handle general errors such as network issues
      throw AortemAuth0SocialLoginException(
        message: 'Failed to complete social login',
        errorDetails: e.toString(),
      );
    }
  }

  /// Closes the underlying HTTP client to free up resources.
  ///
  /// This method should be called when the [AortemAuth0SocialLogin] instance is no longer needed,
  /// such as when the application is being closed or when switching clients.
  void close() {
    httpClient.close();
  }
}
