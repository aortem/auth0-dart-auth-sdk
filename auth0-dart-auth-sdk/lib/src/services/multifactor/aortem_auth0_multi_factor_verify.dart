import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_multi_factor_verify_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_multi_factor_verify_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_multi_factor_verify_response_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class AortemAuth0MultiFactorService {
  final Uri auth0DomainUri;
  final Duration timeout;

  AortemAuth0MultiFactorService({
    required this.auth0DomainUri,
    this.timeout = const Duration(seconds: 10),
  });

  Future<AortemAuth0MultiFactorVerifyResponse> verify(
    AortemAuth0MultiFactorVerifyRequest request,
  ) async {
    if (request.mfaToken.isEmpty || request.otp.isEmpty) {
      throw ArgumentError('Both mfaToken and otp must be provided.');
    }

    final url = auth0DomainUri.resolve('/mfa/verify');
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode(request.toJson());

    final response =
        await http.post(url, headers: headers, body: body).timeout(timeout);

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
