import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_authorize_application_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/authorization/aortem_auth0_authorize_application.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemAuth0AuthorizeApplicationService', () {
    final service = AortemAuth0AuthorizeApplicationService();
    final domain = Uri.parse('https://test.auth0.com');

    test('throws ArgumentError when required fields are missing', () {
      expect(
        () => service.buildAuthorizationUrl(
          auth0DomainUri: Uri.parse(''),
          request: AortemAuth0AuthorizeApplicationRequest(
            clientId: '',
            redirectUri: Uri.parse(''),
            responseType: '',
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('builds correct URL with only required fields', () {
      final request = AortemAuth0AuthorizeApplicationRequest(
        clientId: 'testClientId',
        redirectUri: Uri.parse('https://app.com/callback'),
        responseType: 'code',
      );

      final response = service.buildAuthorizationUrl(
        auth0DomainUri: domain,
        request: request,
      );

      final url = response.url;
      expect(url.toString(), contains('https://test.auth0.com/authorize'));
      expect(url.queryParameters['client_id'], 'testClientId');
      expect(url.queryParameters['redirect_uri'], 'https://app.com/callback');
      expect(url.queryParameters['response_type'], 'code');
    });

    test('includes all optional parameters when provided', () {
      final request = AortemAuth0AuthorizeApplicationRequest(
        clientId: 'optionalTest',
        redirectUri: Uri.parse('https://app.com/return'),
        responseType: 'code',
        scope: 'openid email',
        state: 'xyz123',
        audience: 'https://api.myapp.com',
        connection: 'google-oauth2',
        prompt: 'login',
      );

      final response = service.buildAuthorizationUrl(
        auth0DomainUri: domain,
        request: request,
      );

      final params = response.url.queryParameters;
      expect(params['scope'], 'openid email');
      expect(params['state'], 'xyz123');
      expect(params['audience'], 'https://api.myapp.com');
      expect(params['connection'], 'google-oauth2');
      expect(params['prompt'], 'login');
    });
  });
}
