import '../../../lib/src/logout/auth0_saml_logout.dart';
import '../../../lib/src/models/auth0_saml_logout_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0SamlLogout', () {
    test('builds logout url with required parameters', () {
      final service = Auth0SamlLogout(domain: 'example.auth0.com');
      final response = service.buildLogoutUrl(
        Auth0SamlLogoutRequest(clientId: 'client-id'),
      );

      final uri = Uri.parse(response.logoutUrl);
      expect(uri.host, equals('example.auth0.com'));
      expect(uri.path, equals('/samlp/logout'));
      expect(uri.queryParameters['client_id'], equals('client-id'));
    });

    test('includes optional parameters when provided', () {
      final service = Auth0SamlLogout(domain: 'example.auth0.com');
      final response = service.buildLogoutUrl(
        Auth0SamlLogoutRequest(
          clientId: 'client-id',
          returnTo: 'https://app.example.com/post-logout',
          federated: true,
        ),
      );

      final uri = Uri.parse(response.logoutUrl);
      expect(
        uri.queryParameters['returnTo'],
        equals('https://app.example.com/post-logout'),
      );
      expect(uri.queryParameters['federated'], equals('true'));
    });
  });
}
