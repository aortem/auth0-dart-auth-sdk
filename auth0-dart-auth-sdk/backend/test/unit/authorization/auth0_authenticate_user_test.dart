import '../../../lib/src/models/auth0_authenticate_user_request_model.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0AuthenticateUserRequest', () {
    test('throws an exception for invalid request parameters', () {
      expect(
        () => Auth0AuthenticateUserRequest(
          username: '',
          password: 'password123',
          connection: 'Username-Password-Authentication',
          clientId: 'your-client-id',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('serializes password realm requests with realm field', () {
      final request = Auth0AuthenticateUserRequest(
        username: 'user@example.com',
        password: 'password123',
        connection: 'Username-Password-Authentication',
        clientId: 'your-client-id',
        usePasswordRealm: true,
      );

      expect(
        request.toJson(),
        equals({
          'grant_type': 'http://auth0.com/oauth/grant-type/password-realm',
          'username': 'user@example.com',
          'password': 'password123',
          'realm': 'Username-Password-Authentication',
          'client_id': 'your-client-id',
        }),
      );
    });
  });
}
