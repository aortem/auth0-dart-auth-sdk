import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_token_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_get_token_request.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_get_token_response.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Requests an authentication token from Auth0's OAuth 2.0 token endpoint.
///
/// This function handles communication with Auth0's `/oauth/token` endpoint to
/// obtain access tokens, ID tokens, and refresh tokens using various OAuth 2.0 flows.
/// It supports all standard grant types defined in [AortemAuth0GetTokenRequest].
///
/// Usage Example:
/// ```dart
/// try {
///   final response = await aortemAuth0GetToken(
///     domain: 'your-domain.auth0.com',
///     request: AortemAuth0GetTokenRequest(
///       grantType: 'authorization_code',
///       clientId: 'your_client_id',
///       code: 'received_authorization_code',
///       redirectUri: 'https://your.app/callback',
///     ),
///   );
///   print('Access Token: ${response.accessToken}');
/// } on AortemAuth0TokenException catch (e) {
///   print('Error getting token: ${e.message}');
/// }
/// ```
///
/// Throws [AortemAuth0TokenException] when:
/// - The request fails (network issues)
/// - Auth0 returns an error response (invalid credentials, expired codes, etc.)
/// - The response cannot be parsed
///
/// Parameters:
///   - `domain`: The Auth0 domain (e.g., 'your-tenant.auth0.com')
///   - `request`: Configured [AortemAuth0GetTokenRequest] with parameters for the desired OAuth flow
///   - `client`: Optional [http.Client] for testing or custom HTTP handling
///
/// Returns:
///   A [Future<AortemAuth0GetTokenResponse>] containing the tokens on success
///
/// Note:
/// For production use, ensure proper error handling and consider implementing
/// token storage and refresh logic.
Future<AortemAuth0GetTokenResponse> aortemAuth0GetToken({
  required String domain,
  required AortemAuth0GetTokenRequest request,
  http.Client? client,
}) async {
  final uri = Uri.https(domain, '/oauth/token');
  final httpClient = client ?? http.Client();

  final response = await httpClient.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(request.toJson()),
  );

  if (response.statusCode == 200) {
    try {
      final jsonBody = jsonDecode(response.body);
      return AortemAuth0GetTokenResponse.fromJson(jsonBody);
    } catch (e) {
      throw AortemAuth0TokenException('Failed to parse response: $e');
    }
  } else {
    try {
      final jsonError = jsonDecode(response.body);
      throw AortemAuth0TokenException(
        jsonError['error_description'] ?? jsonError['error'] ?? 'Unknown error',
        response.statusCode,
      );
    } catch (_) {
      throw AortemAuth0TokenException(
        'Token request failed with status ${response.statusCode}',
      );
    }
  }
}
