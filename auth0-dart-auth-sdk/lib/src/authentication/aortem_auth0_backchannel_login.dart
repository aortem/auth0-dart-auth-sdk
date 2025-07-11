import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../exceptions/aortem_auth0_back_channel_login_exception.dart';
import '../models/aortem_auth0_back_channel_login_request_model.dart';
import '../models/aortem_auth0_back_channel_login_response_model.dart';

/// A class to handle back-channel login with Auth0.
///
/// This class manages the process of sending a back-channel login request to Auth0
/// and handling the response. It allows initiating the login process and handles errors
/// such as invalid responses or failed requests. The timeout duration for HTTP requests
/// can also be customized.
///
/// Example usage:
/// ```dart
/// final loginService = AortemAuth0BackChannelLogin(domain: 'example.auth0.com');
/// try {
///   final response = await loginService.initiate(
///     clientId: 'your-client-id',
///     loginHint: 'user@example.com',
///   );
///   print(response);
/// } catch (e) {
///   print('Login failed: $e');
/// }
/// ```
class AortemAuth0BackChannelLogin {
  /// The Auth0 domain to be used in the back-channel login request (e.g., 'example.auth0.com').
  final String domain;

  /// The HTTP client used to make requests. If not provided, a new client is used.
  final http.Client httpClient;

  /// The timeout duration for HTTP requests.
  final Duration timeout;

  /// Constructor for creating an instance of [AortemAuth0BackChannelLogin].
  ///
  /// [domain] is the Auth0 domain used for the back-channel login request.
  /// [httpClient] is an optional parameter. If not provided, a new instance of [http.Client] is created.
  /// [timeout] specifies the duration before a request times out. The default is 10 seconds.
  AortemAuth0BackChannelLogin({
    required this.domain,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : httpClient = httpClient ?? http.Client();

  /// Initiates a back-channel login request to Auth0.
  ///
  /// [clientId] is the client ID for the Auth0 application.
  /// [loginHint] is the user's username or email address.
  /// [scope] is an optional OAuth2 scope for the request.
  /// [acrValues] is an optional parameter used for authentication context class references.
  /// [bindingMessage] is an optional parameter used for passing a binding message.
  ///
  /// Returns an [AortemAuth0BackChannelLoginResponse] on successful login.
  ///
  /// Throws [AortemAuth0BackChannelLoginException] if the request fails or if the response is invalid.
  Future<AortemAuth0BackChannelLoginResponse> initiate({
    required String clientId,
    required String loginHint,
    String? scope,
    String? acrValues,
    String? bindingMessage,
  }) async {
    final request = AortemAuth0BackChannelLoginRequest(
      clientId: clientId,
      loginHint: loginHint,
      scope: scope,
      acrValues: acrValues,
      bindingMessage: bindingMessage,
    );

    try {
      // Make the POST request to Auth0 backchannel login endpoint
      final response = await httpClient
          .post(
            Uri.parse('https://$domain/bc-authorize'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(timeout);

      // Handle successful response
      if (response.statusCode == 200) {
        return AortemAuth0BackChannelLoginResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        // Handle failed response
        throw AortemAuth0BackChannelLoginException(
          message: 'Back-channel login failed',
          statusCode: response.statusCode,
          errorDetails: response.body,
        );
      }
    } on FormatException catch (e) {
      // Handle invalid response format
      throw AortemAuth0BackChannelLoginException(
        message: 'Invalid response format from Auth0',
        errorDetails: e.toString(),
      );
    } catch (e) {
      // Handle all other errors
      throw AortemAuth0BackChannelLoginException(
        message: 'Failed to complete back-channel login',
        errorDetails: e.toString(),
      );
    }
  }

  /// Closes the underlying HTTP client to free up resources.
  ///
  /// This method should be called when the [AortemAuth0BackChannelLogin] instance
  /// is no longer needed, such as at the end of the app lifecycle or when switching clients.
  void close() {
    httpClient.close();
  }
}
