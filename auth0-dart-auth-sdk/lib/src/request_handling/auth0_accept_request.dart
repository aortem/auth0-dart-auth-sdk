import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../exceptions/auth0_accept_request_exception.dart';
import '../models/auth0_accept_request_request_model.dart';
import '../models/auth0_accept_request_response_model.dart';

/// A client for handling passwordless authentication with Auth0's magic links.
///
/// This client provides methods to accept passwordless authentication requests
/// and exchange them for authentication tokens.
class Auth0AcceptRequestClient {
  /// The Auth0 domain (e.g., 'your-domain.auth0.com').
  final String auth0Domain;

  /// The underlying HTTP client used to make requests.
  final http.Client _httpClient;

  /// Creates a new [Auth0AcceptRequestClient] instance.
  ///
  /// [auth0Domain] must be a valid Auth0 domain. An optional [httpClient] can be
  /// provided for testing or customization; if not provided, a default client
  /// will be used.
  Auth0AcceptRequestClient({required this.auth0Domain, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Accepts a passwordless authentication request and exchanges it for tokens.
  ///
  /// This method sends a request to Auth0's token endpoint to accept the
  /// passwordless authentication request identified by the provided [request].
  ///
  /// Throws [ArgumentError] if the request parameters are invalid.
  /// Throws [Auth0AcceptRequestException] if the API request fails.
  /// Throws other exceptions for network or parsing errors.
  Future<Auth0AcceptRequestResponse> acceptRequest(
    Auth0AcceptRequestRequest request,
  ) async {
    if (request.clientId.isEmpty || request.ticket.isEmpty) {
      throw ArgumentError('Both clientId and ticket are required.');
    }

    final url = Uri.https(auth0Domain, '/oauth/token');

    final body = {
      'grant_type':
          'http://auth0.com/oauth/grant-type/passwordless/accept-request',
      'client_id': request.clientId,
      'ticket': request.ticket,
    };

    try {
      final response = await _httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return Auth0AcceptRequestResponse.fromJson(jsonMap);
      } else {
        throw Auth0AcceptRequestException(
          'Failed to accept passwordless request: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Auth0AcceptRequestException('Unexpected error: $e');
    }
  }
}
