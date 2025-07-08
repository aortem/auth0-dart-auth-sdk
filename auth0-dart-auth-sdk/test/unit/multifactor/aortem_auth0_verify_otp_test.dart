import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_verify_otp_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/multifactor/aortem_auth0_verify_otp.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/testing.dart';

void main() {
  group('AortemAuth0MfaApiClient.verifyOTP', () {
    const auth0Domain = 'https://example.auth0.com';
    late AortemAuth0MfaVerifyOpt client;

    test('returns AortemAuth0VerifyOTPResponse on success', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), equals('$auth0Domain/oauth/token'));
        expect(request.method, equals('POST'));

        final body = jsonDecode(request.body);
        expect(
          body['grant_type'],
          'http://auth0.com/oauth/grant-type/passwordless/otp',
        );
        expect(body['client_id'], 'abc123');
        expect(body['otp'], '123456');

        return http.Response(
          jsonEncode({
            'access_token': 'ACCESS123',
            'id_token': 'IDTOKEN123',
            'refresh_token': 'REFRESH456',
            'token_type': 'Bearer',
            'expires_in': 3600,
          }),
          200,
        );
      });

      client = AortemAuth0MfaVerifyOpt(
        auth0Domain: auth0Domain,
        httpClient: mockClient,
      );

      final request = AortemAuth0VerifyOTPRequest(
        clientId: 'abc123',
        otp: '123456',
        realm: 'email',
        username: 'user@example.com',
      );

      final response = await client.verifyOTP(request);

      expect(response.accessToken, equals('ACCESS123'));
      expect(response.idToken, equals('IDTOKEN123'));
      expect(response.refreshToken, equals('REFRESH456'));
      expect(response.tokenType, equals('Bearer'));
      expect(response.expiresIn, equals(3600));
    });

    test('throws Exception on non-200 response', () async {
      final mockClient = MockClient((_) async {
        return http.Response('{"error":"invalid_grant"}', 400);
      });

      client = AortemAuth0MfaVerifyOpt(
        auth0Domain: auth0Domain,
        httpClient: mockClient,
      );

      final request = AortemAuth0VerifyOTPRequest(
        clientId: 'abc123',
        otp: 'invalid',
        realm: 'email',
        username: 'user@example.com',
      );

      expect(
        () async => await client.verifyOTP(request),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('OTP verification failed'),
          ),
        ),
      );
    });

    test('throws FormatException on invalid JSON', () async {
      final mockClient = MockClient((_) async {
        return http.Response('Invalid JSON', 200);
      });

      client = AortemAuth0MfaVerifyOpt(
        auth0Domain: auth0Domain,
        httpClient: mockClient,
      );

      final request = AortemAuth0VerifyOTPRequest(
        clientId: 'abc123',
        otp: '123456',
        realm: 'email',
        username: 'user@example.com',
      );

      expect(
        () async => await client.verifyOTP(request),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws ArgumentError for missing username when realm is email', () {
      expect(
        () => AortemAuth0VerifyOTPRequest(
          clientId: 'abc123',
          otp: '123456',
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

    test('throws ArgumentError for missing phoneNumber when realm is sms', () {
      expect(
        () => AortemAuth0VerifyOTPRequest(
          clientId: 'abc123',
          otp: '123456',
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
  });
}
