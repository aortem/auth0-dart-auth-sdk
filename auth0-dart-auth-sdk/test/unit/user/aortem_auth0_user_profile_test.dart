import 'dart:convert';

import 'package:auth0_dart_auth_sdk/src/user_info/aortem_auth0_user_profile.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_user_profile_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_user_profile_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_user_profile_exception.dart';

void main() {
  group('AortemAuth0UserProfile', () {
    late AortemAuth0UserProfile service;

    setUp(() {
      service = AortemAuth0UserProfile();
    });

    const auth0Domain = 'example.auth0.com';
    const validToken = 'valid-access-token';

    test('returns user profile on 200 response', () async {
      MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer $validToken');

        return http.Response(
          jsonEncode({
            'sub': 'auth0|123456789',
            'name': 'John Doe',
            'email': 'john@example.com',
          }),
          200,
        );
      });

      final result = await service.aortemAuth0UserProfile(
        AortemAuth0UserProfileRequest(accessToken: validToken),
        auth0Domain,
      );

      expect(result, isA<AortemAuth0UserProfileResponse>());
      expect(result.sub, 'auth0|123456789');
      expect(result.name, 'John Doe');
      expect(result.email, 'john@example.com');
    });

    test('throws exception when access token is missing', () async {
      expect(
        () => service.aortemAuth0UserProfile(
          AortemAuth0UserProfileRequest(accessToken: ''),
          auth0Domain,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws custom exception on 401 unauthorized', () async {
      MockClient((request) async {
        return http.Response(
          jsonEncode({'error_description': 'Invalid token'}),
          401,
        );
      });

      try {
        await service.aortemAuth0UserProfile(
          AortemAuth0UserProfileRequest(accessToken: 'invalid'),
          auth0Domain,
        );
        fail('Expected exception to be thrown');
      } catch (e) {
        expect(e, isA<AortemAuth0UserProfileException>());
        expect(
          (e as AortemAuth0UserProfileException).message,
          contains('Invalid token'),
        );
      }
    });

    test('throws exception if response is not JSON', () async {
      MockClient((request) async {
        return http.Response('Invalid response body', 200);
      });

      expect(
        () => service.aortemAuth0UserProfile(
          AortemAuth0UserProfileRequest(accessToken: validToken),
          auth0Domain,
        ),
        throwsA(isA<AortemAuth0UserProfileException>()),
      );
    });
  });
}
