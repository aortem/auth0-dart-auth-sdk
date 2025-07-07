import 'package:auth0_dart_auth_sdk/src/multifactor/aortem_auth0_list_authenticators.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_list_authenticators_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_list_authenticators_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_list_authenticators_exception.dart';

void main() {
  group('AortemAuth0ListAuthenticators', () {
    const validAccessToken = 'valid-token';
    const invalidAccessToken = '';

    test('returns authenticators list on success (HTTP 200)', () async {
      final service = AortemAuth0ListAuthenticators(validAccessToken);
      final result = await service.fetchAuthenticators(
        AortemAuth0ListAuthenticatorsRequest(validAccessToken),
      );

      expect(result, isA<AortemAuth0ListAuthenticatorsResponse>());
      expect(result.authenticators.length, equals(2));
      expect(result.authenticators[0].id, equals('auth_1'));
      expect(result.authenticators[1].type, equals('sms'));
    });

    test('throws ArgumentError if access token is empty', () {
      expect(
        () => AortemAuth0ListAuthenticators(invalidAccessToken),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
      'throws AortemAuth0ListAuthenticatorsException on HTTP error',
      () async {
        final service = AortemAuth0ListAuthenticators(validAccessToken);
        expect(
          () => service.fetchAuthenticators(
            AortemAuth0ListAuthenticatorsRequest(validAccessToken),
          ),
          throwsA(isA<AortemAuth0ListAuthenticatorsException>()),
        );
      },
    );

    test(
      'throws AortemAuth0ListAuthenticatorsException on JSON parse error',
      () async {
        final service = AortemAuth0ListAuthenticators(validAccessToken);
        expect(
          () => service.fetchAuthenticators(
            AortemAuth0ListAuthenticatorsRequest(validAccessToken),
          ),
          throwsA(isA<AortemAuth0ListAuthenticatorsException>()),
        );
      },
    );

    test(
      'throws AortemAuth0ListAuthenticatorsException on network error',
      () async {
        final service = AortemAuth0ListAuthenticators(validAccessToken);
        expect(
          () => service.fetchAuthenticators(
            AortemAuth0ListAuthenticatorsRequest(validAccessToken),
          ),
          throwsA(isA<AortemAuth0ListAuthenticatorsException>()),
        );
      },
    );
  });
}
