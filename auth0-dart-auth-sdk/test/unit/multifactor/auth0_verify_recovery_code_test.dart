import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/models/auth0_verify_recovery_code_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/multifactor/auth0_verify_recovery_code.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0VerifyRecoveryCode', () {
    setUp(() {
      // Default to real domain; overridden in tests.
    });

    test('should throw ArgumentError if required fields are missing', () {
      expect(
        () => Auth0VerifyRecoveryCodeRequest(
          clientId: '',
          recoveryCode: 'code',
          username: 'user@example.com',
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => Auth0VerifyRecoveryCodeRequest(
          clientId: 'clientId',
          recoveryCode: '',
          username: 'user@example.com',
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => Auth0VerifyRecoveryCodeRequest(
          clientId: 'clientId',
          recoveryCode: 'code',
          username: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should return response on successful verification', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('/oauth/token'));
        expect(request.method, equals('POST'));
        final payload = jsonDecode(request.body);
        expect(
          payload['grant_type'],
          'http://auth0.com/oauth/grant-type/passwordless/recovery-code',
        );

        return http.Response(
          jsonEncode({
            'access_token': 'mock_access_token',
            'id_token': 'mock_id_token',
            'refresh_token': 'mock_refresh_token',
            'token_type': 'Bearer',
            'expires_in': 3600,
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final client = Auth0MfaApiClient(
        auth0Domain: 'https://mock.auth0.com',
        httpClient: mockClient,
      );

      final response = await client.verifyRecoveryCode(
        Auth0VerifyRecoveryCodeRequest(
          clientId: 'test-client-id',
          recoveryCode: 'valid-recovery-code',
          username: 'user@example.com',
        ),
      );

      expect(response.accessToken, 'mock_access_token');
      expect(response.idToken, 'mock_id_token');
      expect(response.refreshToken, 'mock_refresh_token');
      expect(response.tokenType, 'Bearer');
      expect(response.expiresIn, 3600);
    });

    test('should throw exception on error response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'invalid_grant',
            'error_description': 'Invalid code',
          }),
          400,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final client = Auth0MfaApiClient(
        auth0Domain: 'https://mock.auth0.com',
        httpClient: mockClient,
      );

      expect(
        () async => await client.verifyRecoveryCode(
          Auth0VerifyRecoveryCodeRequest(
            clientId: 'client',
            recoveryCode: 'wrong-code',
            username: 'user@example.com',
          ),
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to verify recovery code'),
          ),
        ),
      );
    });

    test('should throw FormatException on invalid JSON response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('invalid-json', 200);
      });

      final client = Auth0MfaApiClient(
        auth0Domain: 'https://mock.auth0.com',
        httpClient: mockClient,
      );

      expect(
        () async => await client.verifyRecoveryCode(
          Auth0VerifyRecoveryCodeRequest(
            clientId: 'client',
            recoveryCode: 'valid-code',
            username: 'user@example.com',
          ),
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
