import '../../../lib/src/exceptions/auth0_list_authenticators_exception.dart';
import '../../../lib/src/models/auth0_list_authenticators_request_model.dart';
import '../../../lib/src/models/auth0_list_authenticators_response_model.dart';
import '../../../lib/src/multifactor/auth0_list_authenticators.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0ListAuthenticators', () {
    const validAccessToken = 'valid-token';
    const invalidAccessToken = '';
    const testDomain = 'example.auth0.com';

    test('returns authenticators list on success (HTTP 200)', () async {
      final service = Auth0ListAuthenticators(
        auth0Domain: testDomain,
        accessToken: validAccessToken,
        httpClient: MockClient((request) async {
          expect(
            request.url.toString(),
            equals('https://example.auth0.com/mfa/authenticators'),
          );

          return http.Response(
            '''
            [
              {"id":"auth_1","type":"totp","name":"Authenticator app"},
              {"id":"auth_2","type":"sms","name":"SMS"}
            ]
            ''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final result = await service.fetchAuthenticators(
        Auth0ListAuthenticatorsRequest(validAccessToken),
      );

      expect(result, isA<Auth0ListAuthenticatorsResponse>());
      expect(result.authenticators.length, equals(2));
      expect(result.authenticators[0].id, equals('auth_1'));
      expect(result.authenticators[1].type, equals('sms'));
    });

    test('throws ArgumentError if access token is empty', () {
      expect(
        () => Auth0ListAuthenticators(
          auth0Domain: testDomain,
          accessToken: invalidAccessToken,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws Auth0ListAuthenticatorsException on HTTP error', () async {
      final service = Auth0ListAuthenticators(
        auth0Domain: testDomain,
        accessToken: validAccessToken,
        httpClient: MockClient((request) async {
          return http.Response('Unauthorized', 401);
        }),
      );

      await expectLater(
        service.fetchAuthenticators(
          Auth0ListAuthenticatorsRequest(validAccessToken),
        ),
        throwsA(isA<Auth0ListAuthenticatorsException>()),
      );
    });

    test(
      'throws Auth0ListAuthenticatorsException on JSON parse error',
      () async {
        final service = Auth0ListAuthenticators(
          auth0Domain: testDomain,
          accessToken: validAccessToken,
          httpClient: MockClient((request) async {
            return http.Response('not-json', 200);
          }),
        );

        await expectLater(
          service.fetchAuthenticators(
            Auth0ListAuthenticatorsRequest(validAccessToken),
          ),
          throwsA(isA<Auth0ListAuthenticatorsException>()),
        );
      },
    );

    test('throws Auth0ListAuthenticatorsException on network error', () async {
      final service = Auth0ListAuthenticators(
        auth0Domain: testDomain,
        accessToken: validAccessToken,
        httpClient: MockClient((request) async {
          throw http.ClientException('network failure');
        }),
      );

      await expectLater(
        service.fetchAuthenticators(
          Auth0ListAuthenticatorsRequest(validAccessToken),
        ),
        throwsA(isA<Auth0ListAuthenticatorsException>()),
      );
    });
  });
}
