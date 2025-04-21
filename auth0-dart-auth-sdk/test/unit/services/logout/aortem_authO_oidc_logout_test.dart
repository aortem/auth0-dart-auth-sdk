import 'package:auth0_dart_auth_sdk/src/models/aortem-autho-oidc-logout-request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem-autho-oidc-logout-response_model.dart';
import 'package:auth0_dart_auth_sdk/src/services/logout/aortem-authO-oidc-logout.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemAuth0OidcLogout', () {
    const domain = 'example.auth0.com';
    final oidcLogoutService = AortemAuth0OidcLogout(auth0Domain: domain);

    test('generates logout URL with only required clientId', () {
      final request = AortemAuth0OidcLogoutRequest(clientId: 'abc123');

      final response = oidcLogoutService.generateLogoutUrl(request);

      expect(response, isA<AortemAuth0OidcLogoutResponse>());
      expect(response.logoutUrl, 'https://$domain/v2/logout?client_id=abc123');
    });

    test('generates logout URL with all optional parameters', () {
      final request = AortemAuth0OidcLogoutRequest(
        clientId: 'abc123',
        idTokenHint: 'id-token-sample',
        postLogoutRedirectUri: 'https://yourapp.com/after-logout',
        state: 'xyz789',
      );

      final response = oidcLogoutService.generateLogoutUrl(request);

      final expectedUri =
          'https://$domain/v2/logout?client_id=abc123&id_token_hint=id-token-sample'
          '&post_logout_redirect_uri=https%3A%2F%2Fyourapp.com%2Fafter-logout'
          '&state=xyz789';

      expect(response.logoutUrl, expectedUri);
    });

    test('throws ArgumentError if clientId is missing', () {
      final request = AortemAuth0OidcLogoutRequest(clientId: '');

      expect(
        () => oidcLogoutService.generateLogoutUrl(request),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('clientId is required'),
          ),
        ),
      );
    });
  });
}
