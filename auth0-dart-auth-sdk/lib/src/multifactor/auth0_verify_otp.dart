import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../models/auth0_verify_otp_request_model.dart';
import '../models/auth0_verify_otp_response_model.dart';

/// A service that handles OTP (One-Time Password) verification using Auth0's MFA endpoint.
///
/// This class is responsible for verifying a one-time password (OTP) as part of
/// a multi-factor authentication (MFA) flow. It sends a token request to the
/// Auth0 `/oauth/token` endpoint and returns a structured response upon success.
///
/// Example usage:
/// ```dart
/// final otpService = Auth0MfaVerifyOpt(auth0Domain: 'https://your-domain.auth0.com');
/// final request = Auth0VerifyOTPRequest(
///   grantType: 'http://auth0.com/oauth/grant-type/mfa-otp',
///   clientId: 'your-client-id',
///   mfaToken: 'your-mfa-token',
///   otp: '123456',
/// );
/// final response = await otpService.verifyOTP(request);
/// print('Access Token: ${response.accessToken}');
/// ```
class Auth0MfaVerifyOpt {
  /// The Auth0 domain (e.g., `https://your-domain.auth0.com`).
  final String auth0Domain;

  /// The HTTP client used to send requests. Defaults to a new [http.Client] if not provided.
  final http.Client httpClient;

  /// Constructs an instance of [Auth0MfaVerifyOpt].
  ///
  /// [auth0Domain] is the base URL of your Auth0 tenant.
  /// Optionally, you can pass a custom [httpClient] for testing or advanced use cases.
  Auth0MfaVerifyOpt({required this.auth0Domain, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  /// Verifies the OTP by making a request to the Auth0 `/oauth/token` endpoint.
  ///
  /// Takes a [request] object containing necessary MFA verification data.
  ///
  /// Returns an [Auth0VerifyOTPResponse] if the verification is successful.
  ///
  /// Throws a [FormatException] if the response cannot be parsed,
  /// or a generic [Exception] if the request fails.
  Future<Auth0VerifyOTPResponse> verifyOTP(
    Auth0VerifyOTPRequest request,
  ) async {
    final url = Uri.parse('$auth0Domain/oauth/token');

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode(request.toJson());

    final response = await httpClient.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Auth0VerifyOTPResponse.fromJson(json);
      } catch (e) {
        throw FormatException('Failed to parse OTP response: $e');
      }
    } else {
      throw Exception(
        'OTP verification failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}
