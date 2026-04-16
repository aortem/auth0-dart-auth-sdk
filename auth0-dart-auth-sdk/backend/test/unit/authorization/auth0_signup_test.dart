import '../../../lib/src/authorization/auth0_signup.dart';
import '../../../lib/src/exceptions/auth0_signup_exception.dart';
import '../../../lib/src/models/auth0_signup_request_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0Signup', () {
    final request = Auth0SignupRequest(
      clientId: 'client-id',
      email: 'user@example.com',
      password: 'password123',
      connection: 'Username-Password-Authentication',
    );

    test('returns signup response on success', () async {
      final service = Auth0Signup(
        client: MockClient((incomingRequest) async {
          expect(
            incomingRequest.url.toString(),
            equals('https://example.auth0.com/dbconnections/signup'),
          );

          return http.Response(
            '{"email":"user@example.com","user_id":"auth0|123"}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await service.auth0Signup(request, 'example.auth0.com');

      expect(response.email, equals('user@example.com'));
      expect(response.userId, equals('auth0|123'));
    });

    test('throws Auth0SignupException on Auth0 errors', () async {
      final service = Auth0Signup(
        client: MockClient((incomingRequest) async {
          return http.Response(
            '{"error_description":"email already exists"}',
            400,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await expectLater(
        service.auth0Signup(request, 'https://example.auth0.com'),
        throwsA(
          isA<Auth0SignupException>().having(
            (e) => e.message,
            'message',
            'email already exists',
          ),
        ),
      );
    });
  });
}
