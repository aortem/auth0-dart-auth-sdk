import 'dart:convert';

import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_add_authenticator_request_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../models/aortem_auth0_add_authenticator_response_model.dart';

/// A client for interacting with Auth0's Multi-Factor Authentication (MFA) API endpoints.
///
/// This client handles network communication with Auth0's MFA services,
/// specifically for adding new authenticators to a user's account.
///
/// Example Usage:
/// ```dart
/// final client = AortemAuth0MfaApiClient(
///   auth0Domain: 'https://your-domain.auth0.com',
///   httpClient: http.Client(),
/// );
///
/// final response = await client.aortemAuth0AddAuthenticator(
///   AortemAuth0AddAuthenticatorRequest(
///     mfaToken: 'abc123xyz...',
///     authenticatorType: 'otp',
///   ),
/// );
/// ```
class AortemAuth0MfaAddAuthenticator {
  /// The base domain URL of the Auth0 tenant.
  ///
  /// Should be in the format: 'https://your-domain.auth0.com'
  /// Must include the HTTPS protocol and should not include any path segments.
  final String auth0Domain;

  /// The HTTP client used to make requests to Auth0's API.
  ///
  /// Can be customized for:
  /// - Testing (using mock clients)
  /// - Adding interceptors
  /// - Configuring timeouts
  final http.Client httpClient;

  /// Creates an instance of the MFA API client.
  ///
  /// Parameters:
  /// - [auth0Domain]: Required base URL of the Auth0 tenant
  /// - [httpClient]: Required HTTP client for making requests
  ///
  /// Throws:
  /// - [ArgumentError] if auth0Domain is empty or invalid
  AortemAuth0MfaAddAuthenticator({
    required this.auth0Domain,
    required this.httpClient,
  }) {
    if (auth0Domain.isEmpty) {
      throw ArgumentError('auth0Domain cannot be empty');
    }
    if (!auth0Domain.startsWith('https://')) {
      throw ArgumentError('auth0Domain must use HTTPS protocol');
    }
  }

  /// Adds a new authenticator for Multi-Factor Authentication.
  ///
  /// This method calls Auth0's `/mfa/associate` endpoint to register
  /// a new authenticator (like TOTP, SMS, or WebAuthn) for the user.
  ///
  /// Parameters:
  /// - [request]: Contains the MFA token and authenticator type
  ///
  /// Returns:
  /// A [Future] that resolves to an [AortemAuth0AddAuthenticatorResponse]
  /// containing details about the newly added authenticator.
  ///
  /// Throws:
  /// - [Exception] if the API request fails (non-200 status code)
  /// - [FormatException] if the response body contains invalid JSON
  /// - Network-related exceptions for connection issues
  Future<AortemAuth0AddAuthenticatorResponse> aortemAuth0AddAuthenticator(
    AortemAuth0AddAuthenticatorRequest request,
  ) async {
    // Construct the full URL to Auth0's MFA association endpoint
    final url = Uri.parse('$auth0Domain/mfa/associate');

    // Set required headers for JSON content
    final headers = {'Content-Type': 'application/json'};

    // Prepare the request body by encoding the request object to JSON
    final body = jsonEncode({
      'mfa_token': request.mfaToken,
      'authenticator_type': request.authenticatorType,
    });

    // Execute the POST request to Auth0's API
    final response = await httpClient.post(url, headers: headers, body: body);

    // Handle successful response (status code 200)
    if (response.statusCode == 200) {
      try {
        // Parse the JSON response
        final data = jsonDecode(response.body);
        // Convert the JSON data to a response object
        return AortemAuth0AddAuthenticatorResponse.fromJson(data);
      } catch (e) {
        // Handle JSON parsing errors
        throw FormatException('Failed to parse response: ${e.toString()}');
      }
    } else {
      // Handle error responses
      throw Exception(
        'Failed to add authenticator: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
