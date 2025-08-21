import 'package:auth0_dart_auth_sdk/src/user_info/auth0_user_profile.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:http/testing.dart';

import 'package:auth0_dart_auth_sdk/src/models/auth0_user_profile_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/exceptions/auth0_user_profile_exception.dart';

void main() {
  group('Auth0UserProfile', () {
    late Auth0UserProfile service;

    setUp(() {
      service = Auth0UserProfile();
    });

    const auth0Domain = 'example.auth0.com';
    const validToken = 'valid-access-token';

    test('throws exception when access token is missing', () async {
      expect(
        () => service.auth0UserProfile(
          Auth0UserProfileRequest(accessToken: ''),
          auth0Domain,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception if response is not JSON', () async {
      MockClient((request) async {
        return http.Response('Invalid response body', 200);
      });

      expect(
        () => service.auth0UserProfile(
          Auth0UserProfileRequest(accessToken: validToken),
          auth0Domain,
        ),
        throwsA(isA<Auth0UserProfileException>()),
      );
    });
  });
}
