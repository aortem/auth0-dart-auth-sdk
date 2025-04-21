import 'package:auth0_dart_auth_sdk/src/models/aortem-autho-social-login-request.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem-autho-social-login-response.dart';
import 'package:auth0_dart_auth_sdk/src/services/authentication/aortem-authO-social-login.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;
  late AortemAuth0SocialLogin socialLogin;
  const domain = 'test.auth0.com';
  const clientId = 'test_client_id';

  setUp(() {
    mockClient = MockClient();
    socialLogin = AortemAuth0SocialLogin(
      domain: domain,
      clientId: clientId,
      httpClient: mockClient,
    );
  });

  tearDown(() {
    socialLogin.close();
  });

  group('AortemAuth0SocialLoginRequest', () {
    test('should create valid request with required fields', () {
      final request = AortemAuth0SocialLoginRequest(
        socialAccessToken: 'social_token',
        connection: 'google-oauth2',
      );

      expect(request.toJson(), {
        'access_token': 'social_token',
        'connection': 'google-oauth2',
      });
    });

    test('should include optional fields when provided', () {
      final request = AortemAuth0SocialLoginRequest(
        socialAccessToken: 'social_token',
        connection: 'google-oauth2',
        clientId: 'custom_client',
        scope: 'openid profile',
        audience: 'api://default',
      );

      expect(request.toJson(), {
        'access_token': 'social_token',
        'connection': 'google-oauth2',
        'client_id': 'custom_client',
        'scope': 'openid profile',
        'audience': 'api://default',
      });
    });

    test('should throw ArgumentError for empty fields', () {
      expect(
        () => AortemAuth0SocialLoginRequest(
          socialAccessToken: '',
          connection: 'google-oauth2',
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => AortemAuth0SocialLoginRequest(
          socialAccessToken: 'social_token',
          connection: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('AortemAuth0SocialLoginResponse', () {
    test('should parse successful response', () {
      final response = AortemAuth0SocialLoginResponse.fromJson({
        'access_token': 'access_token_123',
        'id_token': 'id_token_456',
        'token_type': 'Bearer',
        'refresh_token': 'refresh_token_789',
        'expires_in': 3600,
      });

      expect(response.accessToken, 'access_token_123');
      expect(response.idToken, 'id_token_456');
      expect(response.tokenType, 'Bearer');
      expect(response.refreshToken, 'refresh_token_789');
      expect(response.expiresIn, 3600);
    });

    test('should handle response without optional fields', () {
      final response = AortemAuth0SocialLoginResponse.fromJson({
        'access_token': 'access_token_123',
        'id_token': 'id_token_456',
        'token_type': 'Bearer',
      });

      expect(response.accessToken, 'access_token_123');
      expect(response.idToken, 'id_token_456');
      expect(response.tokenType, 'Bearer');
      expect(response.refreshToken, isNull);
      expect(response.expiresIn, isNull);
    });

    test('should throw FormatException for invalid response', () {
      expect(
        () => AortemAuth0SocialLoginResponse.fromJson({
          'id_token': 'id_token_456',
          'token_type': 'Bearer',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
