import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_multi_factor_verify_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_multi_factor_verify_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_multi_factor_verify_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for handling multi-factor authentication (MFA) operations with Auth0.
///
/// This class provides functionality to verify MFA challenges using Auth0's API.
/// It handles the communication with Auth0's MFA verification endpoint and
/// processes the responses.
///
/// Example usage:
/// ```dart
/// final mfaService = AortemAuth0MultiFactorService(
///   auth0DomainUri: Uri.parse('https://your-domain.auth0.com'),
///   timeout: Duration(seconds: 15),
/// );
///
/// final response = await mfaService.verify(
///   AortemAuth0MultiFactorVerifyRequest(
///     mfaToken: 'your_mfa_token',
///     otp: '123456',
///   ),
/// );
/// ```
class AortemAuth0MultiFactorService {
  /// The base URI of the Auth0 domain (e.g., 'https://your-domain.auth0.com').
  final Uri auth0DomainUri;

  /// The maximum duration to wait for the MFA verification request to complete.
  /// Defaults to 10 seconds.
  final Duration timeout;

  /// Creates an instance of [AortemAuth0MultiFactorService].
  ///
  /// Requires:
  /// - [auth0DomainUri]: The base URI of your Auth0 domain
  /// - [timeout]: Optional timeout duration (default: 10 seconds)
  AortemAuth0MultiFactorService({
    required this.auth0DomainUri,
    this.timeout = const Duration(seconds: 10),
  });

  /// Verifies a multi-factor authentication challenge.
  ///
  /// Sends the OTP code to Auth0 for verification against the provided MFA token.
  ///
  /// Parameters:
  /// - [request]: The verification request containing the MFA token and OTP code
  ///
  /// Returns:
  /// A [Future] that completes with an [AortemAuth0MultiFactorVerifyResponse]
  /// if verification is successful.
  ///
  /// Throws:
  /// - [ArgumentError] if either mfaToken or otp is empty
  /// - [AortemAuth0MultifactorVerifyException] if the verification fails
  /// - [TimeoutException] if the request times out
  /// - Other [Exception] types for network or parsing errors
  Future<AortemAuth0MultiFactorVerifyResponse> verify(
    AortemAuth0MultiFactorVerifyRequest request,
  ) async {
    if (request.mfaToken.isEmpty || request.otp.isEmpty) {
      throw ArgumentError('Both mfaToken and otp must be provided.');
    }

    final url = auth0DomainUri.resolve('/mfa/verify');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode(request.toJson());

    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(timeout);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return AortemAuth0MultiFactorVerifyResponse.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw AortemAuth0MultifactorVerifyException(
        message: error['error_description'] ?? 'MFA verification failed',
        statusCode: response.statusCode,
        details: error,
      );
    }
  }
}
