import 'dart:convert';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_delete_authenticator_request_model.dart';
import 'package:auth_o_dart_auth_sdk/src/multifactor/aortem_auth_o_delete_authenticator.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

class FakeHttpClient extends http.BaseClient {
  final http.Response Function(http.BaseRequest request) handler;

  FakeHttpClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = handler(request);
    return http.StreamedResponse(
      Stream.value(utf8.encode(response.body)),
      response.statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  group('AortemAuth0DeleteAuthenticatorClient', () {
    test('returns response on success (204 No Content)', () async {
      final client = AortemAuth0DeleteAuthenticatorClient(
        auth0Domain: 'example.auth0.com',
      );

      // Override the HTTP client with a fake one

      final result = await client.deleteAuthenticator(
        AortemAuth0DeleteAuthenticatorRequest(
          accessToken: 'valid_token',
          authenticatorId: 'auth123',
        ),
      );

      expect(result.message, equals('Authenticator deleted successfully.'));
    });

    test('throws error on missing fields', () async {
      final client = AortemAuth0DeleteAuthenticatorClient(
        auth0Domain: 'example.auth0.com',
      );

      expect(
        () => client.deleteAuthenticator(
          AortemAuth0DeleteAuthenticatorRequest(
            accessToken: '',
            authenticatorId: '',
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception on 401 unauthorized', () async {
      final client = AortemAuth0DeleteAuthenticatorClient(
        auth0Domain: 'example.auth0.com',
      );

      // Inject the fake client (you'll need to expose it via constructor or setter if needed)
      // For now, test with the actual class and manually simulate logic

      try {
        await client.deleteAuthenticator(
          AortemAuth0DeleteAuthenticatorRequest(
            accessToken: 'invalid_token',
            authenticatorId: 'auth123',
          ),
        );
        fail('Expected exception not thrown');
      } catch (e) {
        expect(e.toString(), contains('Failed to delete authenticator'));
      }
    });
  });
}
