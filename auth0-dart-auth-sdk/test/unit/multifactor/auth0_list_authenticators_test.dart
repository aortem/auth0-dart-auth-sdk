import 'package:auth0_dart_auth_sdk/src/multifactor/auth0_list_authenticators.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:auth0_dart_auth_sdk/src/models/auth0_list_authenticators_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/auth0_list_authenticators_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/exceptions/auth0_list_authenticators_exception.dart';

void main() {
  group('Auth0ListAuthenticators', () {
    const validAccessToken = 'valid-token';
    const invalidAccessToken = '';
    const testDomain = 'example.auth0.com';

    test('returns authenticators list on success (HTTP 200)', () async {
      final service = Auth0ListAuthenticators(
        auth0Domain: testDomain,
        accessToken: validAccessToken,
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
      );
      expect(
        () => service.fetchAuthenticators(
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
        );
        expect(
          () => service.fetchAuthenticators(
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
      );
      expect(
        () => service.fetchAuthenticators(
          Auth0ListAuthenticatorsRequest(validAccessToken),
        ),
        throwsA(isA<Auth0ListAuthenticatorsException>()),
      );
    });
  });
}
