import '../../../lib/src/exceptions/auth0_delete_authenticator_exception.dart';
import '../../../lib/src/models/auth0_delete_authenticator_request_model.dart';
import '../../../lib/src/multifactor/auth0_delete_authenticator.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0DeleteAuthenticatorClient', () {
    test('returns response on success (204 No Content)', () async {
      final client = Auth0DeleteAuthenticatorClient(
        auth0Domain: 'example.auth0.com',
        httpClient: MockClient((request) async {
          expect(
            request.url.toString(),
            equals('https://example.auth0.com/mfa/authenticators/auth123'),
          );
          return http.Response('', 204);
        }),
      );

      final result = await client.deleteAuthenticator(
        Auth0DeleteAuthenticatorRequest(
          accessToken: 'valid_token',
          authenticatorId: 'auth123',
        ),
      );

      expect(result.message, equals('Authenticator deleted successfully.'));
      expect(result.success, isTrue);
    });

    test('throws error on missing fields', () {
      expect(
        () => Auth0DeleteAuthenticatorRequest(
          accessToken: '',
          authenticatorId: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception on 401 unauthorized', () async {
      final client = Auth0DeleteAuthenticatorClient(
        auth0Domain: 'example.auth0.com',
        httpClient: MockClient((request) async {
          return http.Response(
            '{"error":"invalid_grant","error_description":"The mfa_token provided is invalid. Try getting a new token."}',
            401,
          );
        }),
      );

      await expectLater(
        client.deleteAuthenticator(
          Auth0DeleteAuthenticatorRequest(
            accessToken: 'invalid_token',
            authenticatorId: 'auth123',
          ),
        ),
        throwsA(
          isA<Auth0DeleteAuthenticatorException>().having(
            (e) => e.message,
            'message',
            contains('Failed to delete authenticator'),
          ),
        ),
      );
    });
  });
}
