import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/authorization/auth0_get_token.dart';
import 'package:auth0_dart_auth_sdk/src/exceptions/auth0_token_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/auth0_get_token_request.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/testing.dart';

void main() {
  group('Auth0GetToken', () {
    const domain = 'test.auth0.com';

    test('returns Auth0GetTokenResponse on success', () async {
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

      final request = Auth0GetTokenRequest(
        grantType: 'authorization_code',
        clientId: 'myClientId',
        code: 'mockCode',
        redirectUri: 'https://myapp.com/callback',
      );

      final result = await auth0GetToken(
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

    test('throws Auth0TokenException on Auth0 error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': 'invalid_grant',
            'error_description': 'Invalid code.',
          }),
          400,
        );
      });

      final request = Auth0GetTokenRequest(
        grantType: 'authorization_code',
        clientId: 'myClientId',
        code: 'invalidCode',
        redirectUri: 'https://myapp.com/callback',
      );

      expect(
        () =>
            auth0GetToken(domain: domain, request: request, client: mockClient),
        throwsA(
          predicate(
            (e) =>
                e is Auth0TokenException &&
                e.message == 'Invalid code.' &&
                e.statusCode == 400,
          ),
        ),
      );
    });

    test('throws Auth0TokenException on non-JSON error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final request = Auth0GetTokenRequest(
        grantType: 'authorization_code',
        clientId: 'myClientId',
        code: 'someCode',
        redirectUri: 'https://myapp.com/callback',
      );

      expect(
        () =>
            auth0GetToken(domain: domain, request: request, client: mockClient),
        throwsA(
          predicate(
            (e) =>
                e is Auth0TokenException &&
                e.message.contains('Token request failed with status 500'),
          ),
        ),
      );
    });
  });
}
