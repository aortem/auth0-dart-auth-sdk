import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth_o_get_user_info_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_get_user_info_request.dart';
import 'package:auth0_dart_auth_sdk/src/user_info/aortem_auth_o_get_user_info.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

void main() {
  group('aortemAuth0GetUserInfo', () {
    const testDomain = 'auth0.example.com';
    const testAccessToken = 'valid-access-token';

    setUp(() {
      // You could store the old client if you have a global client setup
    });

    tearDown(() {
      // Restore original if needed
    });

    test('returns valid user info response when API returns 200', () async {
      MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer $testAccessToken');
        expect(request.url.toString(), 'https://$testDomain/userinfo');

        return http.Response(
          jsonEncode({
            "sub": "auth0|123456",
            "name": "Jane Doe",
            "email": "jane@example.com",
            "picture": "https://example.com/avatar.png",
            "custom_claim": "extra-value",
          }),
          200,
        );
      });

      final request = AortemAuth0GetUserInfoRequest(
        accessToken: testAccessToken,
      );

      final result = await aortemAuth0GetUserInfo(
        domain: testDomain,
        request: request,
      );

      expect(result.sub, equals("auth0|123456"));
      expect(result.name, equals("Jane Doe"));
      expect(result.email, equals("jane@example.com"));
      expect(result.picture, equals("https://example.com/avatar.png"));
      expect(result.additionalClaims['custom_claim'], equals("extra-value"));
    });

    test('throws exception on non-200 response', () async {
      MockClient((request) async {
        return http.Response(
          jsonEncode({
            "error": "invalid_token",
            "error_description": "The access token is invalid",
          }),
          401,
        );
      });

      final request = AortemAuth0GetUserInfoRequest(
        accessToken: testAccessToken,
      );

      try {
        await aortemAuth0GetUserInfo(domain: testDomain, request: request);
        fail('Should have thrown AortemAuth0UserInfoException');
      } catch (e) {
        expect(e, isA<AortemAuth0UserInfoException>());
        expect(e.toString(), contains('The access token is invalid'));
      }
    });

    test('throws ArgumentError when access token is empty', () {
      expect(
        () => AortemAuth0GetUserInfoRequest(accessToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws parsing error on malformed JSON', () async {
      MockClient((request) async {
        return http.Response('Not a JSON', 200);
      });

      final request = AortemAuth0GetUserInfoRequest(
        accessToken: testAccessToken,
      );

      try {
        await aortemAuth0GetUserInfo(domain: testDomain, request: request);
        fail('Should have thrown AortemAuth0UserInfoException');
      } catch (e) {
        expect(e, isA<AortemAuth0UserInfoException>());
        expect(e.toString(), contains('Failed to parse user info response'));
      }
    });
  });
}
