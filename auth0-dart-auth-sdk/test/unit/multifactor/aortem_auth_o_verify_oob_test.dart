import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_verify_oob_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/multifactor/aortem_auth0_verify_oob.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

// Adjust import paths as needed

void main() {
  group('AortemAuth0VerifyOOB Tests', () {
    const fakeDomain = 'https://example.auth0.com';

    late AortemAuth0MfaVerifyOob apiClient;

    setUp(() {
      // Provide a mock HTTP client for isolation
      apiClient = AortemAuth0MfaVerifyOob(auth0Domain: fakeDomain);
    });

    test('successfully verifies OOB code for email', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), '$fakeDomain/oauth/token');
        expect(request.method, 'POST');

        final body = jsonDecode(request.body);
        expect(
          body['grant_type'],
          'http://auth0.com/oauth/grant-type/passwordless/oob',
        );
        expect(body['realm'], 'email');
        expect(body['username'], 'user@example.com');

        return http.Response(
          jsonEncode({
            'access_token': 'test-access-token',
            'id_token': 'test-id-token',
            'refresh_token': 'test-refresh-token',
            'token_type': 'Bearer',
            'expires_in': 3600,
          }),
          200,
        );
      });

      apiClient = AortemAuth0MfaVerifyOob(
        auth0Domain: fakeDomain,
        httpClient: mockClient,
      );

      final request = AortemAuth0VerifyOOBRequest(
        clientId: 'client-id',
        oobCode: 'oob-code',
        realm: 'email',
        username: 'user@example.com',
      );

      final response = await apiClient.verifyOOB(request);

      expect(response.accessToken, 'test-access-token');
      expect(response.idToken, 'test-id-token');
      expect(response.refreshToken, 'test-refresh-token');
      expect(response.tokenType, 'Bearer');
      expect(response.expiresIn, 3600);
    });

    test('throws error for missing username in email realm', () {
      expect(
        () => AortemAuth0VerifyOOBRequest(
          clientId: 'client-id',
          oobCode: 'code',
          realm: 'email',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Username is required'),
          ),
        ),
      );
    });

    test('throws error for missing phone number in sms realm', () {
      expect(
        () => AortemAuth0VerifyOOBRequest(
          clientId: 'client-id',
          oobCode: 'code',
          realm: 'sms',
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Phone number is required'),
          ),
        ),
      );
    });

    test('throws error on non-200 response from API', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"error": "invalid_request"}', 400);
      });

      apiClient = AortemAuth0MfaVerifyOob(
        auth0Domain: fakeDomain,
        httpClient: mockClient,
      );

      final request = AortemAuth0VerifyOOBRequest(
        clientId: 'client-id',
        oobCode: 'bad-code',
        realm: 'sms',
        phoneNumber: '+1234567890',
      );

      expect(
        () async => await apiClient.verifyOOB(request),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('status 400'),
          ),
        ),
      );
    });

    test('throws format exception on malformed response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('not-json', 200);
      });

      apiClient = AortemAuth0MfaVerifyOob(
        auth0Domain: fakeDomain,
        httpClient: mockClient,
      );

      final request = AortemAuth0VerifyOOBRequest(
        clientId: 'client-id',
        oobCode: 'oob-code',
        realm: 'sms',
        phoneNumber: '+1234567890',
      );

      expect(
        () async => await apiClient.verifyOOB(request),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
