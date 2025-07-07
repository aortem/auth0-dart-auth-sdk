import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../models/aortem_auth0_verify_oob_request_model.dart';
import '../models/aortem_auth0_verify_oob_response_model.dart';

/// A service class responsible for handling Multi-Factor Authentication (MFA)
/// verification using Out-of-Band (OOB) mechanisms with Auth0.
///
/// This class allows verification of OOB codes such as email or SMS codes
/// by making a token request to the Auth0 `/oauth/token` endpoint.
class AortemAuth0MfaVerifyOob {
  /// The base Auth0 domain used to perform the request (e.g., `https://your-tenant.auth0.com`).
  final String auth0Domain;

  /// The HTTP client used for making network requests.
  /// A default client is used if none is provided.
  final http.Client httpClient;

  /// Creates an instance of [AortemAuth0MfaVerifyOob].
  ///
  /// The [auth0Domain] is required and should be your Auth0 tenant URL.
  /// An optional [httpClient] can be passed for testing or custom configuration.
  AortemAuth0MfaVerifyOob({required this.auth0Domain, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  /// Verifies the OOB code provided in the [request] by sending it to Auth0's token endpoint.
  ///
  /// If the verification is successful, it returns an [AortemAuth0VerifyOOBResponse]
  /// containing the access token, ID token, and optionally a refresh token.
  ///
  /// Throws a [FormatException] if the response body cannot be parsed,
  /// or a generic [Exception] if the server returns a non-200 status code.
  Future<AortemAuth0VerifyOOBResponse> verifyOOB(
    AortemAuth0VerifyOOBRequest request,
  ) async {
    final uri = Uri.parse('$auth0Domain/oauth/token');

    final response = await httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        return AortemAuth0VerifyOOBResponse.fromJson(json);
      } catch (e) {
        throw FormatException('Failed to parse response: ${e.toString()}');
      }
    } else {
      throw Exception(
        'OOB verification failed with status ${response.statusCode}: ${response.body}',
      );
    }
  }
}
