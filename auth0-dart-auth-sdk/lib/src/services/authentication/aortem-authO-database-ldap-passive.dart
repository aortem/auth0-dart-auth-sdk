import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../../exceptions/aortem-authO-database-ldap-passive_exception.dart';
import '../../models/aortem-authO-database-ldap-passive_request_model.dart';
import '../../models/aortem-authO-database-ldap-passive_response_model.dart';

/// Handles passive authentication using Database, Active Directory (AD), or LDAP connections with Auth0.
///
/// This class manages the process of authenticating a user through the passive authentication flow
/// for connections such as a database, Active Directory, or LDAP. It sends a request to the Auth0
/// service and processes the response. The class also handles errors, such as failed authentication
/// or invalid responses.
///
/// Example usage:
/// ```dart
/// final authService = AortemAuth0DatabaseAdLdapPassive(
///   domain: 'your-auth0-domain',
///   clientId: 'your-client-id',
/// );
/// try {
///   final response = await authService.authenticate(
///     username: 'user@example.com',
///     password: 'password123',
///     connection: 'your-connection',
///   );
///   print(response);
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class AortemAuth0DatabaseAdLdapPassive {
  /// The Auth0 domain to be used for authentication (e.g., 'example.auth0.com').
  final String domain;

  /// The client ID for the Auth0 application.
  final String clientId;

  /// The HTTP client used to send requests. A new [http.Client] is used if not provided.
  final http.Client httpClient;

  /// The timeout duration for HTTP requests. Defaults to 10 seconds.
  final Duration timeout;

  /// Constructs an instance of [AortemAuth0DatabaseAdLdapPassive].
  ///
  /// [domain] is the Auth0 domain used for the passive authentication request.
  /// [clientId] is the client ID for the Auth0 application.
  /// [httpClient] is an optional parameter. If not provided, a new [http.Client] instance is used.
  /// [timeout] specifies the duration before a request times out. The default is 10 seconds.
  AortemAuth0DatabaseAdLdapPassive({
    required this.domain,
    required this.clientId,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 10),
  }) : httpClient = httpClient ?? http.Client();

  /// Authenticates a user using the passive authentication flow.
  ///
  /// [username] is the user's username or email address.
  /// [password] is the user's password.
  /// [connection] is the name of the connection (e.g., 'database', 'ldap').
  /// [scope] is an optional OAuth2 scope for the request.
  /// [audience] is an optional parameter for the audience in the authentication request.
  ///
  /// Returns an [AortemAuth0DatabaseAdLdapPassiveResponse] on successful authentication.
  ///
  /// Throws [AortemAuth0DatabaseAdLdapPassiveException] if the request fails or the response is invalid.
  Future<AortemAuth0DatabaseAdLdapPassiveResponse> authenticate({
    required String username,
    required String password,
    required String connection,
    String? scope,
    String? audience,
  }) async {
    final request = AortemAuth0DatabaseAdLdapPassiveRequest(
      username: username,
      password: password,
      connection: connection,
      clientId: clientId,
      scope: scope,
      audience: audience,
    );

    try {
      // Make the POST request to the Auth0 database/AD/LDAP passive authentication endpoint
      final response = await httpClient
          .post(
            Uri.parse('https://$domain/usernamepassword/passive'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(timeout);

      // Handle successful response
      if (response.statusCode == 200) {
        return AortemAuth0DatabaseAdLdapPassiveResponse.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // Handle failed authentication
        throw AortemAuth0DatabaseAdLdapPassiveException(
          message: 'Passive authentication failed',
          statusCode: response.statusCode,
          errorDetails: response.body,
        );
      }
    } on FormatException catch (e) {
      // Handle invalid response format from Auth0
      throw AortemAuth0DatabaseAdLdapPassiveException(
        message: 'Invalid response format from Auth0',
        errorDetails: e.toString(),
      );
    } catch (e) {
      // Handle general errors such as network issues
      throw AortemAuth0DatabaseAdLdapPassiveException(
        message: 'Failed to complete passive authentication',
        errorDetails: e.toString(),
      );
    }
  }

  /// Closes the underlying HTTP client to free up resources.
  ///
  /// This method should be called when the [AortemAuth0DatabaseAdLdapPassive] instance
  /// is no longer needed, such as when the application is being closed or when switching clients.
  void close() {
    httpClient.close();
  }
}
