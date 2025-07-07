import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_challenge_request_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/multifactor/aortem_auth0_challenge_request.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

void main() {
  group('AortemAuth0MfaApiClient', () {
    const domain = 'https://example.auth0.com';

    test('returns AortemAuth0ChallengeResponse on success', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), equals('$domain/mfa/challenge'));
        expect(request.method, equals('POST'));
        expect(request.headers['Content-Type'], equals('application/json'));

        final body = jsonDecode(request.body);
        expect(body['mfa_token'], equals('test-token'));

        return http.Response(
          jsonEncode({
            'challenge_id': 'abc123',
            'expires_in': 300,
            'message': 'Challenge sent',
          }),
          200,
        );
      });

      final client = AortemAuthOMultifactorChallengeRequest(
        auth0Domain: domain,
        httpClient: mockClient,
      );

      final response = await client.requestChallenge(
        AortemAuth0ChallengeRequest(mfaToken: 'test-token'),
      );

      expect(response.challengeId, equals('abc123'));
      expect(response.expiresIn, equals(300));
      expect(response.message, equals('Challenge sent'));
    });

    test('throws FormatException on invalid JSON', () async {
      final mockClient = MockClient((request) async {
        return http.Response('not json', 200);
      });

      final client = AortemAuthOMultifactorChallengeRequest(
        auth0Domain: domain,
        httpClient: mockClient,
      );

      expect(
        () => client.requestChallenge(
          AortemAuth0ChallengeRequest(mfaToken: 'test-token'),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws Exception on non-200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      final client = AortemAuthOMultifactorChallengeRequest(
        auth0Domain: domain,
        httpClient: mockClient,
      );

      expect(
        () => client.requestChallenge(
          AortemAuth0ChallengeRequest(mfaToken: 'bad-token'),
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Challenge request failed: 401'),
          ),
        ),
      );
    });

    test('throws ArgumentError when mfaToken is missing', () async {
      final client = AortemAuthOMultifactorChallengeRequest(
        auth0Domain: domain,
      );
      expect(
        () =>
            client.requestChallenge(AortemAuth0ChallengeRequest(mfaToken: '')),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
