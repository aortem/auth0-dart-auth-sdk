import '../../../lib/src/authentication/auth0_login.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0LoginService', () {
    late Auth0LoginService authService;
    const testDomain = 'test.auth0.com';
    final validRequest = Auth0LoginRequest(
      username: 'test@example.com',
      password: 'password123',
      connection: 'Username-Password-Authentication',
      clientId: 'test_client_id',
    );

    setUp(() {
      authService = Auth0LoginService(
        auth0Domain: testDomain,
        requestTimeout: const Duration(seconds: 1),
      );
    });

    tearDown(() {
      authService.dispose();
    });

    test('request converts to correct JSON', () {
      // Arrange
      final request = Auth0LoginRequest(
        username: 'user@test.com',
        password: 'pass123',
        connection: 'test-connection',
        clientId: 'test-client',
        scope: 'openid',
        audience: 'test-audience',
        additionalParameters: {'param1': 'value1'},
      );

      // Act
      final json = request.toJson();

      // Assert
      expect(
        json,
        equals({
          'grant_type': 'http://auth0.com/oauth/grant-type/password-realm',
          'username': 'user@test.com',
          'password': 'pass123',
          'realm': 'test-connection',
          'client_id': 'test-client',
          'scope': 'openid',
          'audience': 'test-audience',
          'param1': 'value1',
        }),
      );
    });

    test('throws timeout exception when request takes too long', () async {
      final delayedClient = MockClient((request) async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return http.Response(
          '{"access_token":"token","token_type":"Bearer"}',
          200,
        );
      });

      final timeoutService = Auth0LoginService(
        auth0Domain: testDomain,
        client: delayedClient,
        requestTimeout: const Duration(milliseconds: 100),
      );

      expect(
        () => timeoutService.login(validRequest),
        throwsA(
          isA<Auth0LoginException>().having(
            (e) => e.message,
            'message',
            'Request timed out',
          ),
        ),
      );
    });

    test('parses successful response correctly', () {
      // Test the response parsing logic directly
      final jsonResponse = {
        'access_token': 'test_token',
        'token_type': 'Bearer',
        'expires_in': 3600,
        'refresh_token': 'refresh_token',
        'id_token': 'id_token',
        'extra_field': 'extra_value',
      };

      final response = Auth0LoginResponse.fromJson(jsonResponse);

      expect(response.accessToken, 'test_token');
      expect(response.tokenType, 'Bearer');
      expect(response.expiresIn, 3600);
      expect(response.refreshToken, 'refresh_token');
      expect(response.idToken, 'id_token');
      expect(response.additionalData, {'extra_field': 'extra_value'});
    });
  });
}
