import '../../../lib/src/dynamic_registration/auth0_dynamic_application_client_registration.dart';
import '../../../lib/src/models/auth0_dynamic_application_client_registration_request_model.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('Auth0AuthorizeApplicationBuilder', () {
    test('builds a valid URL with all parameters', () {
      final domain = Uri.parse('https://example.auth0.com');
      final request = Auth0AuthorizeApplicationClientRegisterRequest(
        clientId: 'abc123',
        redirectUri: Uri.parse('https://app.example.com/callback'),
        responseType: 'code',
        scope: 'openid profile',
        state: 'xyz',
        audience: 'https://api.example.com',
        connection: 'google-oauth2',
        prompt: 'login',
      );

      final response = Auth0AuthorizeApplicationBuilder.build(
        auth0DomainUri: domain,
        request: request,
      );

      expect(response.url.queryParameters['client_id'], equals('abc123'));
      expect(
        response.url.queryParameters['redirect_uri'],
        equals('https://app.example.com/callback'),
      );
      expect(response.url.queryParameters['response_type'], equals('code'));
      expect(response.url.queryParameters['scope'], equals('openid profile'));
      expect(response.url.queryParameters['state'], equals('xyz'));
      expect(
        response.url.queryParameters['audience'],
        equals('https://api.example.com'),
      );
      expect(
        response.url.queryParameters['connection'],
        equals('google-oauth2'),
      );
      expect(response.url.queryParameters['prompt'], equals('login'));
    });

    test('throws ArgumentError when clientId is empty', () {
      expect(
        () => Auth0AuthorizeApplicationBuilder.build(
          auth0DomainUri: Uri.parse('https://example.auth0.com'),
          request: Auth0AuthorizeApplicationClientRegisterRequest(
            clientId: '',
            redirectUri: Uri.parse('https://callback.com'),
            responseType: 'code',
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when redirectUri is empty', () {
      expect(
        () => Auth0AuthorizeApplicationBuilder.build(
          auth0DomainUri: Uri.parse('https://example.auth0.com'),
          request: Auth0AuthorizeApplicationClientRegisterRequest(
            clientId: 'abc',
            redirectUri: Uri.parse(''),
            responseType: 'code',
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when responseType is empty', () {
      expect(
        () => Auth0AuthorizeApplicationBuilder.build(
          auth0DomainUri: Uri.parse('https://example.auth0.com'),
          request: Auth0AuthorizeApplicationClientRegisterRequest(
            clientId: 'abc',
            redirectUri: Uri.parse('https://callback.com'),
            responseType: '',
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
