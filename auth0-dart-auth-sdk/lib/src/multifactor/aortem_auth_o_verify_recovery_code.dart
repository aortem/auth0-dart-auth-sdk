import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_verify_recovery_code_request_model.dart';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_verify_recovery_code_response_model.dart';

/// Client for interacting with Auth0's MFA/recovery API endpoints
///
/// Handles network communication with Auth0 for recovery code operations
class AortemAuth0MfaApiClient {
  /// Base URL of the Auth0 tenant domain
  /// Example: "https://your-tenant.auth0.com"
  /// Must include protocol (https)
  final String auth0Domain;

  /// HTTP client for making network requests
  /// Can be customized for testing or configuration
  final http.Client httpClient;

  /// Constructs an MFA API client instance
  ///
  /// Parameters:
  ///   [auth0Domain] - Required Auth0 tenant domain URL
  ///   [httpClient] - Optional custom HTTP client
  ///
  /// Uses default [http.Client] if none provided
  AortemAuth0MfaApiClient({required this.auth0Domain, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  /// Verifies a recovery code with Auth0's token endpoint
  ///
  /// Parameters:
  ///   [request] - Required verification request data
  ///
  /// Returns:
  ///   Future resolving to [AortemAuth0VerifyRecoveryCodeResponse] on success
  ///
  /// Throws:
  ///   [Exception] for non-200 HTTP responses
  ///   [FormatException] for invalid JSON responses
  Future<AortemAuth0VerifyRecoveryCodeResponse> verifyRecoveryCode(
    AortemAuth0VerifyRecoveryCodeRequest request,
  ) async {
    // Construct full URL to Auth0's token endpoint
    final url = Uri.parse('$auth0Domain/oauth/token');

    // Execute POST request to Auth0
    final response = await httpClient.post(
      url,
      // Set JSON content type header
      headers: {'Content-Type': 'application/json'},
      // Serialize request body to JSON
      body: jsonEncode(request.toJson()),
    );

    // Handle non-successful responses
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to verify recovery code. Status ${response.statusCode}: ${response.body}',
      );
    }

    try {
      // Parse JSON response body
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      // Convert JSON to response model
      return AortemAuth0VerifyRecoveryCodeResponse.fromJson(jsonBody);
    } catch (e) {
      // Handle JSON parsing errors
      throw FormatException('Invalid JSON response: ${response.body}');
    }
  }
}
