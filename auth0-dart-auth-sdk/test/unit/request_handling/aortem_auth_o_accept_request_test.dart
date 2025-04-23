import 'dart:convert';
import 'package:auth_o_dart_auth_sdk/src/exceptions/aortem_auth_o_accept_request_exception.dart';
import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_accept_request_request_model.dart';
import 'package:auth_o_dart_auth_sdk/src/request_handling/aortem_auth_o_accept_request.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/testing.dart';

void main() {
  group('AortemAuth0AcceptRequestClient', () {
    const testDomain = 'example.auth0.com';

    test('should return valid response on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), 'https://$testDomain/oauth/token');
        final body = jsonDecode(request.body);
        expect(body['client_id'], equals('abc123'));
        expect(body['ticket'], equals('sample-ticket'));

        return http.Response(
          jsonEncode({
            'access_token': 'access123',
            'id_token': 'id456',
            'refresh_token': 'refresh789',
            'token_type': 'Bearer',
            'expires_in': 3600,
          }),
          200,
        );
      });

      final client = AortemAuth0AcceptRequestClient(
        auth0Domain: testDomain,
        httpClient: mockClient,
      );

      final response = await client.acceptRequest(
        AortemAuth0AcceptRequestRequest(
          clientId: 'abc123',
          ticket: 'sample-ticket',
        ),
      );

      expect(response.accessToken, 'access123');
      expect(response.idToken, 'id456');
      expect(response.refreshToken, 'refresh789');
      expect(response.tokenType, 'Bearer');
      expect(response.expiresIn, 3600);
    });

    test(
      'should throw ArgumentError when required fields are missing',
      () async {
        final client = AortemAuth0AcceptRequestClient(auth0Domain: testDomain);

        expect(
          () => client.acceptRequest(
            AortemAuth0AcceptRequestRequest(clientId: '', ticket: ''),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('should throw custom exception on API failure', () async {
      final mockClient = MockClient((_) async {
        return http.Response('Invalid ticket', 400);
      });

      final client = AortemAuth0AcceptRequestClient(
        auth0Domain: testDomain,
        httpClient: mockClient,
      );

      expect(
        () => client.acceptRequest(
          AortemAuth0AcceptRequestRequest(
            clientId: 'abc123',
            ticket: 'bad-ticket',
          ),
        ),
        throwsA(
          isA<AortemAuth0AcceptRequestException>().having(
            (e) => e.toString(),
            'contains error',
            contains('400'),
          ),
        ),
      );
    });

    test('should throw exception on unexpected error', () async {
      final mockClient = MockClient((_) async {
        throw Exception('Network error');
      });

      final client = AortemAuth0AcceptRequestClient(
        auth0Domain: testDomain,
        httpClient: mockClient,
      );

      expect(
        () => client.acceptRequest(
          AortemAuth0AcceptRequestRequest(
            clientId: 'abc123',
            ticket: 'ticket123',
          ),
        ),
        throwsA(isA<AortemAuth0AcceptRequestException>()),
      );
    });
  });
}
