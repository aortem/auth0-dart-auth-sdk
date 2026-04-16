import '../../../lib/src/models/auth0_get_code_or_link_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0GetCodeOrLinkRequest', () {
    test('throws an exception for invalid request parameters', () {
      expect(
        () => Auth0GetCodeOrLinkRequest(
          clientId: '',
          connection: 'email',
          email: 'user@example.com',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('serializes request data for passwordless delivery', () {
      final request = Auth0GetCodeOrLinkRequest(
        clientId: 'client-id',
        connection: 'email',
        email: 'user@example.com',
        send: 'code',
        authParams: {'scope': 'openid'},
      );

      expect(
        request.toJson(),
        equals({
          'client_id': 'client-id',
          'connection': 'email',
          'email': 'user@example.com',
          'send': 'code',
          'authParams': {'scope': 'openid'},
        }),
      );
    });
  });
}
