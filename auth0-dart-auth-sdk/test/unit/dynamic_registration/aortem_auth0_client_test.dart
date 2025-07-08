import 'package:auth0_dart_auth_sdk/src/dynamic_registration/aortem_auth0_dynamic_application_client_registration.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_dynamic_application_client_registration_request_model.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemAuth0AuthorizeApplicationBuilder', () {
    test('builds a valid URL with all parameters', () {
      final domain = Uri.parse('https://example.auth0.com');
      final request = AortemAuth0AuthorizeApplicationClientRegisterRequest(
        clientId: 'abc123',
        redirectUri: Uri.parse('https://app.example.com/callback'),
        responseType: 'code',
        scope: 'openid profile',
        state: 'xyz',
        audience: 'https://api.example.com',
        connection: 'google-oauth2',
        prompt: 'login',
      );

      final response = AortemAuth0AuthorizeApplicationBuilder.build(
        auth0DomainUri: domain,
        request: request,
      );

      expect(response.url.toString(), contains('client_id=abc123'));
      expect(
        response.url.toString(),
        contains('redirect_uri=https%3A%2F%2Fapp.example.com%2Fcallback'),
      );
      expect(response.url.toString(), contains('response_type=code'));
      expect(response.url.toString(), contains('scope=openid%20profile'));
      expect(response.url.toString(), contains('state=xyz'));
      expect(
        response.url.toString(),
        contains('audience=https%3A%2F%2Fapi.example.com'),
      );
      expect(response.url.toString(), contains('connection=google-oauth2'));
      expect(response.url.toString(), contains('prompt=login'));
    });

    test('throws ArgumentError when clientId is empty', () {
      expect(
        () => AortemAuth0AuthorizeApplicationBuilder.build(
          auth0DomainUri: Uri.parse('https://example.auth0.com'),
          request: AortemAuth0AuthorizeApplicationClientRegisterRequest(
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
        () => AortemAuth0AuthorizeApplicationBuilder.build(
          auth0DomainUri: Uri.parse('https://example.auth0.com'),
          request: AortemAuth0AuthorizeApplicationClientRegisterRequest(
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
        () => AortemAuth0AuthorizeApplicationBuilder.build(
          auth0DomainUri: Uri.parse('https://example.auth0.com'),
          request: AortemAuth0AuthorizeApplicationClientRegisterRequest(
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
