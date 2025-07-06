import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_authenticate_user_request_model.dart';
import 'package:auth_o_dart_auth_sdk/src/authorization/aortem_auth_o_authenticate_user.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:ds_tools_testing/ds_tools_testing.dart';

// Create a mock client
class MockClient extends Mock implements http.Client {}

void main() {
  group('AortemAuth0AuthenticateUser', () {
    late AortemAuth0AuthenticateUser auth0AuthenticateUser;

    setUp(() {
      auth0AuthenticateUser = AortemAuth0AuthenticateUser(
        domain: 'your-tenant.auth0.com',
      );
    });

    test(
      'authenticate should throw an exception for invalid request parameters',
      () {
        final request = AortemAuth0AuthenticateUserRequest(
          username: '',
          password: 'password123',
          connection: 'Username-Password-Authentication',
          clientId: 'your-client-id',
        );

        // Expecting ArgumentError due to empty username
        expect(
          () => auth0AuthenticateUser.authenticate(request: request),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
