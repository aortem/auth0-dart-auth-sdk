import '../../../lib/src/exceptions/auth0_multi_factor_verify_exception.dart';
import '../../../lib/src/models/auth0_multi_factor_verify_request_model.dart';
import '../../../lib/src/multifactor/auth0_multi_factor_verify.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0MultiFactorService', () {
    test('returns response on successful MFA verification', () async {
      final service = Auth0MultiFactorService(
        auth0DomainUri: Uri.parse('https://example.auth0.com'),
        client: MockClient((request) async {
          expect(
            request.url.toString(),
            equals('https://example.auth0.com/mfa/verify'),
          );
          return http.Response(
            '''
            {
              "access_token":"access-token",
              "id_token":"id-token",
              "refresh_token":"refresh-token",
              "token_type":"Bearer",
              "expires_in":3600
            }
            ''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await service.verify(
        Auth0MultiFactorVerifyRequest(mfaToken: 'mfa-token', otp: '123456'),
      );

      expect(response.accessToken, equals('access-token'));
      expect(response.idToken, equals('id-token'));
      expect(response.refreshToken, equals('refresh-token'));
      expect(response.tokenType, equals('Bearer'));
      expect(response.expiresIn, equals(3600));
    });

    test('throws ArgumentError when request is incomplete', () async {
      final service = Auth0MultiFactorService(
        auth0DomainUri: Uri.parse('https://example.auth0.com'),
      );

      await expectLater(
        service.verify(Auth0MultiFactorVerifyRequest(mfaToken: '', otp: '')),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws Auth0MultifactorVerifyException on Auth0 error', () async {
      final service = Auth0MultiFactorService(
        auth0DomainUri: Uri.parse('https://example.auth0.com'),
        client: MockClient((request) async {
          return http.Response(
            '{"error":"invalid_grant","error_description":"Invalid verification code"}',
            400,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await expectLater(
        service.verify(
          Auth0MultiFactorVerifyRequest(mfaToken: 'mfa-token', otp: '000000'),
        ),
        throwsA(
          isA<Auth0MultifactorVerifyException>()
              .having((e) => e.message, 'message', 'Invalid verification code')
              .having((e) => e.statusCode, 'statusCode', 400),
        ),
      );
    });
  });
}
