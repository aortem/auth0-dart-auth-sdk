import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  test('package entrypoint exposes representative public models', () {
    final loginRequest = Auth0LoginRequest(
      username: 'user@example.com',
      password: 'password123',
      connection: 'Username-Password-Authentication',
      clientId: 'client-id',
    );
    final signupRequest = Auth0SignupRequest(
      clientId: 'client-id',
      email: 'user@example.com',
      password: 'password123',
      connection: 'Username-Password-Authentication',
    );
    final samlLogoutRequest = Auth0SamlLogoutRequest(clientId: 'client-id');
    final acceptRequestClient = Auth0AcceptRequestClient(
      auth0Domain: 'example.auth0.com',
    );

    expect(loginRequest.clientId, equals('client-id'));
    expect(signupRequest.email, equals('user@example.com'));
    expect(samlLogoutRequest.toQueryParams()['client_id'], equals('client-id'));
    expect(acceptRequestClient.auth0Domain, equals('example.auth0.com'));
  });
}
