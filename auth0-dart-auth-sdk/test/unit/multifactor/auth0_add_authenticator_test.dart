import 'dart:convert';

import 'package:auth0_dart_auth_sdk/src/models/auth0_add_authenticator_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/multifactor/auth0_add_authenticator.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/testing.dart';

void main() {
  group('Auth0AddAuthenticator', () {
    setUp(() {});

    test('should throw ArgumentError if required fields are missing', () {
      expect(
        () => Auth0AddAuthenticatorRequest(
          mfaToken: '',
          authenticatorType: 'otp',
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => Auth0AddAuthenticatorRequest(
          mfaToken: 'token',
          authenticatorType: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
      'should return response on successful authenticator enrollment',
      () async {
        final mockClient = MockClient((request) async {
          final payload = jsonDecode(request.body);
          expect(payload['mfa_token'], 'valid-mfa-token');
          expect(payload['authenticator_type'], 'otp');

          return http.Response(
            jsonEncode({
              'secret': 'mock-shared-secret',
              'qrCodeUrl': 'http://mock-qr-code-url.com',
            }),
            200,
            headers: {'Content-Type': 'application/json'},
          );
        });

        final client = Auth0MfaAddAuthenticator(
          auth0Domain: 'https://mock.auth0.com',
          httpClient: mockClient,
        );

        final response = await client.auth0AddAuthenticator(
          Auth0AddAuthenticatorRequest(
            mfaToken: 'valid-mfa-token',
            authenticatorType: 'otp',
          ),
        );

        expect(response.secret, 'mock-shared-secret');
        expect(response.qrCodeUrl, 'http://mock-qr-code-url.com');
      },
    );

    test('should throw exception on error response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'invalid_token',
            'error_description': 'Invalid MFA token',
          }),
          400,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final client = Auth0MfaAddAuthenticator(
        auth0Domain: 'https://mock.auth0.com',
        httpClient: mockClient,
      );

      expect(
        () async => await client.auth0AddAuthenticator(
          Auth0AddAuthenticatorRequest(
            mfaToken: 'invalid-mfa-token',
            authenticatorType: 'otp',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw FormatException on invalid JSON response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('invalid-json', 200);
      });

      final client = Auth0MfaAddAuthenticator(
        auth0Domain: 'https://mock.auth0.com',
        httpClient: mockClient,
      );

      expect(
        () async => await client.auth0AddAuthenticator(
          Auth0AddAuthenticatorRequest(
            mfaToken: 'valid-mfa-token',
            authenticatorType: 'otp',
          ),
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
