import 'package:auth0_dart_auth_sdk/src/sso_federation/aortem_auth_o_idp_initiated_sso.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemAuth0IdpInitiatedSSOFlow', () {
    test('should throw ArgumentError if clientId is missing', () {
      expect(
        () => AortemAuth0IdpInitiatedSSOFlowRequest(clientId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should create a valid SSO URL with only required parameters', () {
      final request = AortemAuth0IdpInitiatedSSOFlowRequest(clientId: 'abc123');

      final response = aortemAuth0IdpInitiatedSSOFlow(
        auth0DomainUri: Uri.parse('https://example.auth0.com'),
        request: request,
      );

      expect(response.ssoUrl.scheme, 'https');
      expect(response.ssoUrl.host, 'example.auth0.com');
      expect(response.ssoUrl.path, '/login');
      expect(response.ssoUrl.queryParameters['client'], 'abc123');
      expect(
        response.ssoUrl.queryParameters.containsKey('redirect_uri'),
        isFalse,
      );
      expect(
        response.ssoUrl.queryParameters.containsKey('connection'),
        isFalse,
      );
      expect(response.ssoUrl.queryParameters.containsKey('protocol'), isFalse);
    });

    test('should create a valid SSO URL with all parameters', () {
      final request = AortemAuth0IdpInitiatedSSOFlowRequest(
        clientId: 'abc123',
        redirectUri: 'https://myapp.com/callback',
        connection: 'google-oauth2',
        protocol: 'oidc',
      );

      final response = aortemAuth0IdpInitiatedSSOFlow(
        auth0DomainUri: Uri.parse('https://example.auth0.com'),
        request: request,
      );

      expect(response.ssoUrl.scheme, 'https');
      expect(response.ssoUrl.host, 'example.auth0.com');
      expect(response.ssoUrl.path, '/login');
      expect(response.ssoUrl.queryParameters['client'], 'abc123');
      expect(
        response.ssoUrl.queryParameters['redirect_uri'],
        'https://myapp.com/callback',
      );
      expect(response.ssoUrl.queryParameters['connection'], 'google-oauth2');
      expect(response.ssoUrl.queryParameters['protocol'], 'oidc');
    });

    test('should throw Exception if URL construction fails', () {
      // Simulating URL construction failure by providing an invalid URI
      final request = AortemAuth0IdpInitiatedSSOFlowRequest(clientId: 'abc123');

      expect(
        () => aortemAuth0IdpInitiatedSSOFlow(
          auth0DomainUri: Uri.parse('invalid-url'),
          request: request,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
