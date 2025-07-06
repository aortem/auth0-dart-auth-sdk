import 'dart:convert';

import 'package:auth0_dart_auth_sdk/src/authentication/aortem_auth0_login.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AortemAuth0LoginService authService;
  late MockHttpClient mockHttpClient;
  final auth0Domain = 'test-domain.auth0.com';
  final clientId = 'test-client-id';
  final connection = 'test-connection';

  setUp(() {
    mockHttpClient = MockHttpClient();
    authService = AortemAuth0LoginService(auth0Domain: auth0Domain);
  });

  group('AortemAuth0LoginService', () {
    final validRequest = AortemAuth0LoginRequest(
      username: 'test@example.com',
      password: 'test-password',
      connection: connection,
      clientId: clientId,
    );

    final successResponse = {
      'access_token': 'test-access-token',
      'refresh_token': 'test-refresh-token',
      'id_token': 'test-id-token',
      'token_type': 'Bearer',
      'expires_in': 3600,
    };

    test('should be instantiated with auth0Domain', () {
      expect(authService.auth0Domain, equals(auth0Domain));
    });

    group('login', () {
      test('should make POST request to correct URL', () async {
        // Arrange
        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200),
        );

        // Act
        await authService.login(validRequest);

        // Assert
        verify(
          () => mockHttpClient.post(
            Uri.parse('https://$auth0Domain/oauth/token'),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          ),
        ).called(1);
      });

      test('should include correct request body', () async {
        // Arrange
        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200),
        );

        // Act
        await authService.login(validRequest);

        // Assert
        final expectedBody = jsonEncode({
          'username': validRequest.username,
          'password': validRequest.password,
          'connection': validRequest.connection,
          'client_id': validRequest.clientId,
          'scope': 'openid profile email',
          'audience': null,
        });

        final actualBody =
            verify(
                  () => mockHttpClient.post(
                    any(),
                    headers: any(named: 'headers'),
                    body: captureAny(named: 'body'),
                  ),
                ).captured.single
                as String;

        expect(jsonDecode(actualBody), equals(jsonDecode(expectedBody)));
      });

      test('should return AortemAuth0LoginResponse on success', () async {
        // Arrange
        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200),
        );

        // Act
        final result = await authService.login(validRequest);

        // Assert
        expect(result, isA<AortemAuth0LoginResponse>());
        expect(result.accessToken, equals(successResponse['access_token']));
        expect(result.refreshToken, equals(successResponse['refresh_token']));
        expect(result.idToken, equals(successResponse['id_token']));
        expect(result.tokenType, equals(successResponse['token_type']));
        expect(result.expiresIn, equals(successResponse['expires_in']));
      });

      test('should include custom scope if provided', () async {
        // Arrange
        final customScopeRequest = AortemAuth0LoginRequest(
          username: 'test@example.com',
          password: 'test-password',
          connection: connection,
          clientId: clientId,
          scope: 'openid profile email offline_access',
        );

        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200),
        );

        // Act
        await authService.login(customScopeRequest);

        // Assert
        final expectedBody = jsonEncode({
          'username': customScopeRequest.username,
          'password': customScopeRequest.password,
          'connection': customScopeRequest.connection,
          'client_id': customScopeRequest.clientId,
          'scope': 'openid profile email offline_access',
          'audience': null,
        });

        final actualBody =
            verify(
                  () => mockHttpClient.post(
                    any(),
                    headers: any(named: 'headers'),
                    body: captureAny(named: 'body'),
                  ),
                ).captured.single
                as String;

        expect(jsonDecode(actualBody), equals(jsonDecode(expectedBody)));
      });

      test('should include audience if provided', () async {
        // Arrange
        final audienceRequest = AortemAuth0LoginRequest(
          username: 'test@example.com',
          password: 'test-password',
          connection: connection,
          clientId: clientId,
          audience: 'test-audience',
        );

        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(successResponse), 200),
        );

        // Act
        await authService.login(audienceRequest);

        // Assert
        final expectedBody = jsonEncode({
          'username': audienceRequest.username,
          'password': audienceRequest.password,
          'connection': audienceRequest.connection,
          'client_id': audienceRequest.clientId,
          'scope': 'openid profile email',
          'audience': 'test-audience',
        });

        final actualBody =
            verify(
                  () => mockHttpClient.post(
                    any(),
                    headers: any(named: 'headers'),
                    body: captureAny(named: 'body'),
                  ),
                ).captured.single
                as String;

        expect(jsonDecode(actualBody), equals(jsonDecode(expectedBody)));
      });

      test(
        'should throw AortemAuth0LoginException on non-200 response',
        () async {
          // Arrange
          final errorResponse = {
            'error': 'invalid_grant',
            'error_description': 'Wrong email or password',
          };
          when(
            () => mockHttpClient.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => http.Response(jsonEncode(errorResponse), 403),
          );

          // Act & Assert
          expect(
            () => authService.login(validRequest),
            throwsA(
              isA<AortemAuth0LoginException>().having(
                (e) => e.message,
                'message',
                'Login failed: ${jsonEncode(errorResponse)}',
              ),
            ),
          );
        },
      );

      test(
        'should throw AortemAuth0LoginException on http client exception',
        () async {
          // Arrange
          when(
            () => mockHttpClient.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenThrow(http.ClientException('Network error'));

          // Act & Assert
          expect(
            () => authService.login(validRequest),
            throwsA(
              isA<AortemAuth0LoginException>().having(
                (e) => e.message,
                'message',
                'Login failed: Network error',
              ),
            ),
          );
        },
      );

      test('should throw FormatException on invalid JSON response', () async {
        // Arrange
        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response('invalid-json', 200));

        // Act & Assert
        expect(
          () => authService.login(validRequest),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
