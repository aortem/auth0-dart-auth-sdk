import 'package:auth0_dart_auth_sdk/src/models/aortem-authO-authenticate-user_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/services/authorization/aortem-authO-authenticate-user.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';

// Create a mock client
class MockClient extends Mock implements http.Client {}

void main() {
  group('AortemAuth0AuthenticateUser', () {
    late MockClient mockClient;
    late AortemAuth0AuthenticateUser auth0AuthenticateUser;

    setUp(() {
      mockClient = MockClient();
      auth0AuthenticateUser =
          AortemAuth0AuthenticateUser(domain: 'your-tenant.auth0.com');
    });

    test('authenticate should return success when statusCode is 200', () async {
      final request = AortemAuth0AuthenticateUserRequest(
        username: 'user@example.com',
        password: 'password123',
        connection: 'Username-Password-Authentication',
        clientId: 'your-client-id',
      );

      // Mock HTTP response with a successful response
      when(mockClient.post(
        Uri.https('your-tenant.auth0.com', '/oauth/token'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
          json.encode({
            'access_token': 'accessToken',
            'id_token': 'idToken',
            'token_type': 'Bearer',
            'expires_in': 3600
          }),
          200));

      // Call the method
      final response =
          await auth0AuthenticateUser.authenticate(request: request);

      // Verify the response
      expect(response.accessToken, 'accessToken');
      expect(response.idToken, 'idToken');
      expect(response.tokenType, 'Bearer');
      expect(response.expiresIn, 3600);
    });

    test('authenticate should throw an exception when statusCode is not 200',
        () async {
      final request = AortemAuth0AuthenticateUserRequest(
        username: 'user@example.com',
        password: 'password123',
        connection: 'Username-Password-Authentication',
        clientId: 'your-client-id',
      );

      // Mock HTTP response with an error
      when(mockClient.post(
        Uri.https('your-tenant.auth0.com', '/oauth/token'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Authentication failed', 400));

      // Expect an exception to be thrown
      expect(
        () async => await auth0AuthenticateUser.authenticate(request: request),
        throwsA(isA<Exception>()),
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
      expect(() => auth0AuthenticateUser.authenticate(request: request),
          throwsA(isA<ArgumentError>()));
    });
  });
}
