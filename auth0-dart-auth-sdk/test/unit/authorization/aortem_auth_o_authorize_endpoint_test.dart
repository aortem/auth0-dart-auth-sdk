import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_authorize_endpoint_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_authorize_endpoint_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/authorization/aortem_auth0_authorize_endpoint.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('AortemAuth0AuthorizeEndpoint', () {
    final domainUri = Uri.parse('https://my-domain.auth0.com');

    test('throws ArgumentError when auth0DomainUri is empty', () {
      expect(
        () => AortemAuth0AuthorizeEndpoint(auth0DomainUri: Uri.parse('')),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
      'throws ArgumentError when required fields are missing in request',
      () {
        final endpoint = AortemAuth0AuthorizeEndpoint(
          auth0DomainUri: domainUri,
        );

        final invalidRequest = AortemAuth0AuthorizeEndpointRequest(
          clientId: '',
          redirectUri: Uri.parse(''),
          responseType: '',
          scope: '',
          state: '',
          nonce: '',
        );

        expect(
          () => endpoint.generateAuthorizeUrl(request: invalidRequest),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'returns AortemAuth0AuthorizeEndpointResponse with correct URL (minimum valid fields)',
      () {
        final endpoint = AortemAuth0AuthorizeEndpoint(
          auth0DomainUri: domainUri,
        );

        final request = AortemAuth0AuthorizeEndpointRequest(
          clientId: 'abc123',
          redirectUri: Uri.parse('https://example.com/callback'),
          responseType: 'code',
          scope: 'openid',
          state: 'state123',
          nonce: 'nonce123',
        );

        final response = endpoint.generateAuthorizeUrl(request: request);

        expect(response, isA<AortemAuth0AuthorizeEndpointResponse>());
        expect(response.url.queryParameters['client_id'], equals('abc123'));
        expect(
          response.url.queryParameters['redirect_uri'],
          equals('https://example.com/callback'),
        );
        expect(response.url.queryParameters['response_type'], equals('code'));
        expect(response.url.queryParameters['scope'], equals('openid'));
        expect(response.url.queryParameters['state'], equals('state123'));
        expect(response.url.queryParameters['nonce'], equals('nonce123'));
      },
    );

    test(
      'returns AortemAuth0AuthorizeEndpointResponse with all parameters',
      () {
        final endpoint = AortemAuth0AuthorizeEndpoint(
          auth0DomainUri: domainUri,
        );

        final request = AortemAuth0AuthorizeEndpointRequest(
          clientId: 'abc123',
          redirectUri: Uri.parse('https://example.com/callback'),
          responseType: 'code',
          scope: 'openid profile email',
          state: 'state123',
          nonce: 'nonce456',
          prompt: 'login',
          maxAge: 3600,
          connection: 'google-oauth2',
        );

        final response = endpoint.generateAuthorizeUrl(request: request);
        final uri = response.url;

        expect(uri.queryParameters['client_id'], equals('abc123'));
        expect(
          uri.queryParameters['redirect_uri'],
          equals('https://example.com/callback'),
        );
        expect(uri.queryParameters['response_type'], equals('code'));
        expect(uri.queryParameters['scope'], equals('openid profile email'));
        expect(uri.queryParameters['state'], equals('state123'));
        expect(uri.queryParameters['nonce'], equals('nonce456'));
        expect(uri.queryParameters['prompt'], equals('login'));
        expect(uri.queryParameters['max_age'], equals('3600'));
        expect(uri.queryParameters['connection'], equals('google-oauth2'));
      },
    );
  });
}
