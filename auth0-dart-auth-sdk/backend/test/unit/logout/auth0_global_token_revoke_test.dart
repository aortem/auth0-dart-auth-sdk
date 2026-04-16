import '../../../lib/src/logout/auth0_global_token_revoke.dart';
import '../../../lib/src/models/auth0_global_token_revocation_request.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0GlobalTokenRevocation', () {
    final request = Auth0GlobalTokenRevocationRequest(
      token: 'token-value',
      clientId: 'client-id',
      tokenTypeHint: 'refresh_token',
    );

    test('returns success on 200 response', () async {
      final service = Auth0GlobalTokenRevocation(
        domain: 'example.auth0.com',
        client: MockClient((incomingRequest) async {
          expect(
            incomingRequest.url.toString(),
            equals('https://example.auth0.com/oauth/revoke'),
          );
          expect(
            incomingRequest.headers['Content-Type'],
            contains('application/x-www-form-urlencoded'),
          );
          return http.Response('', 200);
        }),
      );

      final response = await service.revokeToken(request: request);

      expect(response.success, isTrue);
    });

    test('throws on unsuccessful responses', () async {
      final service = Auth0GlobalTokenRevocation(
        domain: 'example.auth0.com',
        client: MockClient((incomingRequest) async {
          return http.Response('invalid token', 400);
        }),
      );

      await expectLater(
        service.revokeToken(request: request),
        throwsA(isA<Exception>()),
      );
    });
  });
}
