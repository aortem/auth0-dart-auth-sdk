import 'dart:convert';
import 'package:auth_o_dart_auth_sdk/src/authorization/aortem_auth0_get_token.dart';
import 'package:auth_o_dart_auth_sdk/src/exceptions/aortem_auth_o_token_exception.dart';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_get_token_request.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('aortemAuth0GetToken', () {
    const domain = 'test.auth0.com';

    test('returns AortemAuth0GetTokenResponse on success', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('/oauth/token'));

        return http.Response(
          jsonEncode({
            'access_token': 'mockAccessToken',
            'id_token': 'mockIdToken',
            'refresh_token': 'mockRefreshToken',
            'token_type': 'Bearer',
            'expires_in': 3600,
          }),
          200,
        );
      });

      final request = AortemAuth0GetTokenRequest(
        grantType: 'authorization_code',
        clientId: 'myClientId',
        code: 'mockCode',
        redirectUri: 'https://myapp.com/callback',
      );

      final result = await aortemAuth0GetToken(
        domain: domain,
        request: request,
        client: mockClient,
      );

      expect(result.accessToken, equals('mockAccessToken'));
      expect(result.idToken, equals('mockIdToken'));
      expect(result.refreshToken, equals('mockRefreshToken'));
      expect(result.tokenType, equals('Bearer'));
      expect(result.expiresIn, equals(3600));
    });

    test('throws AortemAuth0TokenException on Auth0 error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'invalid_grant',
            'error_description': 'Invalid code.',
          }),
          400,
        );
      });

      final request = AortemAuth0GetTokenRequest(
        grantType: 'authorization_code',
        clientId: 'myClientId',
        code: 'invalidCode',
        redirectUri: 'https://myapp.com/callback',
      );

      expect(
        () => aortemAuth0GetToken(
          domain: domain,
          request: request,
          client: mockClient,
        ),
        throwsA(
          predicate(
            (e) =>
                e is AortemAuth0TokenException &&
                e.message == 'Invalid code.' &&
                e.statusCode == 400,
          ),
        ),
      );
    });

    test('throws AortemAuth0TokenException on non-JSON error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final request = AortemAuth0GetTokenRequest(
        grantType: 'authorization_code',
        clientId: 'myClientId',
        code: 'someCode',
        redirectUri: 'https://myapp.com/callback',
      );

      expect(
        () => aortemAuth0GetToken(
          domain: domain,
          request: request,
          client: mockClient,
        ),
        throwsA(
          predicate(
            (e) =>
                e is AortemAuth0TokenException &&
                e.message.contains('Token request failed with status 500'),
          ),
        ),
      );
    });
  });
}
