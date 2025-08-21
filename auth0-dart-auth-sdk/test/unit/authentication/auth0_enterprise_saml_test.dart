import 'package:auth0_dart_auth_sdk/src/authentication/auth0_enterprise_saml.dart';
import 'package:auth0_dart_auth_sdk/src/models/auth0_enterprise_saml_request_model.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0EnterpriseSaml', () {
    test('buildAuthorizeUrl creates correct URL', () {
      final auth0 = Auth0EnterpriseSaml(
        domain: 'test-tenant.auth0.com',
        clientId: 'test-client-id',
      );

      final request = Auth0EnterpriseSamlRequest(
        connection: 'saml-enterprise',
        redirectUri: 'https://example.com/callback',
        state: 'abc123',
      );

      final url = auth0.buildAuthorizeUrl(request);

      expect(url.scheme, 'https');
      expect(url.host, 'test-tenant.auth0.com');
      expect(url.path, '/authorize');
      expect(url.queryParameters['client_id'], 'test-client-id');
      expect(url.queryParameters['connection'], 'saml-enterprise');
      expect(
        url.queryParameters['redirect_uri'],
        'https://example.com/callback',
      );
      expect(url.queryParameters['state'], 'abc123');
    });

    test('isConfigurationValid returns true for valid config', () {
      final auth0 = Auth0EnterpriseSaml(
        domain: 'valid.auth0.com',
        clientId: 'abc123',
      );

      expect(auth0.isConfigurationValid, isTrue);
    });

    test('isConfigurationValid returns false for invalid config', () {
      final auth0 = Auth0EnterpriseSaml(
        domain: 'invalid-domain.com',
        clientId: '',
      );

      expect(auth0.isConfigurationValid, isFalse);
    });
  });
}
