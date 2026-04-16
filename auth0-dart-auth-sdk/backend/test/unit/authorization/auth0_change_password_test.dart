import '../../../lib/src/authorization/auth0_change_password.dart';
import '../../../lib/src/exceptions/auth0_change_password_exception.dart';
import '../../../lib/src/models/auth0_change_password_request_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0ChangePassword', () {
    final request = Auth0ChangePasswordRequest(
      clientId: 'client-id',
      email: 'user@example.com',
      connection: 'Username-Password-Authentication',
    );

    test('returns plain-text success responses', () async {
      final service = Auth0ChangePassword(
        client: MockClient((incomingRequest) async {
          expect(
            incomingRequest.url.toString(),
            equals('https://example.auth0.com/dbconnections/change_password'),
          );

          return http.Response(
            'We have just sent you an email to reset your password.',
            200,
            headers: {'content-type': 'text/plain'},
          );
        }),
      );

      final response = await service.auth0ChangePassword(
        request,
        'example.auth0.com',
      );

      expect(
        response.message,
        equals('We have just sent you an email to reset your password.'),
      );
    });

    test('returns JSON success responses', () async {
      final service = Auth0ChangePassword(
        client: MockClient((incomingRequest) async {
          return http.Response(
            '{"message":"email sent"}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await service.auth0ChangePassword(
        request,
        'https://example.auth0.com',
      );

      expect(response.message, equals('email sent'));
    });

    test('throws Auth0ChangePasswordException on Auth0 errors', () async {
      final service = Auth0ChangePassword(
        client: MockClient((incomingRequest) async {
          return http.Response(
            '{"error_description":"user not found"}',
            400,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await expectLater(
        service.auth0ChangePassword(request, 'example.auth0.com'),
        throwsA(
          isA<Auth0ChangePasswordException>().having(
            (e) => e.message,
            'message',
            'user not found',
          ),
        ),
      );
    });
  });
}
