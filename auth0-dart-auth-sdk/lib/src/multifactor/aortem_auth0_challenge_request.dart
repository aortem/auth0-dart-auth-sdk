import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_challenge_request_request_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../models/aortem_auth0_challenge_request_response_model.dart';

/// A service class for initiating Multi-Factor Authentication (MFA) challenges
/// with Auth0's authentication service.
///
/// This class handles the communication with Auth0's MFA challenge endpoint
/// (/mfa/challenge) to request a new authentication challenge when MFA is required.
///
/// Typical workflow:
/// 1. User completes primary authentication
/// 2. System detects MFA is required (receives mfa_token)
/// 3. This service is used to request a challenge
/// 4. User completes the challenge (e.g., enters OTP code)
///
/// Example Usage:
/// ```dart
/// final challengeService = AortemAuthOMultifactorChallengeRequest(
///   auth0Domain: 'https://your-domain.auth0.com',
/// );
///
/// final response = await challengeService.requestChallenge(
///   AortemAuth0ChallengeRequest(
///     mfaToken: 'received_mfa_token',
///     challengeType: 'otp',
///   ),
/// );
/// ```
class AortemAuthOMultifactorChallengeRequest {
  /// The base Auth0 domain URL (e.g., 'https://your-domain.auth0.com').
  ///
  /// This should match your Auth0 tenant domain and include the https scheme.
  /// Do not include trailing slashes or path segments.
  final String auth0Domain;

  /// The HTTP client used to make requests to Auth0's API.
  ///
  /// Can be customized for:
  /// - Testing (mock clients)
  /// - Custom configuration (timeouts, interceptors)
  /// - Reuse across services
  ///
  /// Defaults to a standard [http.Client] if none provided.
  final http.Client httpClient;

  /// Creates an instance of the MFA challenge request service.
  ///
  /// Parameters:
  /// - [auth0Domain]: Required base URL of your Auth0 tenant
  /// - [httpClient]: Optional custom HTTP client
  ///
  /// Throws:
  /// - [ArgumentError] if auth0Domain is empty or invalid
  AortemAuthOMultifactorChallengeRequest({
    required this.auth0Domain,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client() {
    if (auth0Domain.isEmpty) {
      throw ArgumentError('auth0Domain cannot be empty');
    }
    if (!auth0Domain.startsWith('https://')) {
      throw ArgumentError('auth0Domain must use HTTPS protocol');
    }
  }

  /// Requests a new MFA challenge from Auth0's API.
  ///
  /// This initiates the second factor of authentication by requesting
  /// a challenge based on the user's enrolled MFA factors.
  ///
  /// Parameters:
  /// - [request]: The challenge request containing:
  ///   * mfaToken: From initial authentication
  ///   * challengeType: Preferred method (optional)
  ///
  /// Returns:
  /// A [Future<AortemAuth0ChallengeResponse>] containing:
  /// - challengeId: For subsequent verification
  /// - expiresIn: Challenge validity duration
  /// - message: User instructions
  ///
  /// Throws:
  /// - [FormatException] if response parsing fails
  /// - [Exception] for HTTP errors (with status code and body)
  /// - [ArgumentError] for invalid requests
  /// - Network-related exceptions for connection issues
  Future<AortemAuth0ChallengeResponse> requestChallenge(
    AortemAuth0ChallengeRequest request,
  ) async {
    // Construct the full endpoint URL
    final url = Uri.parse('$auth0Domain/mfa/challenge');

    // Set required headers
    final headers = {'Content-Type': 'application/json'};

    // Serialize the request body
    final body = jsonEncode(request.toJson());

    // Execute the HTTP POST request
    final response = await httpClient.post(url, headers: headers, body: body);

    // Handle successful responses
    if (response.statusCode == 200) {
      try {
        // Parse and validate the JSON response
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AortemAuth0ChallengeResponse.fromJson(json);
      } catch (e) {
        throw FormatException('Failed to parse challenge response: $e');
      }
    } else {
      // Handle error responses
      throw Exception(
        'Challenge request failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}
