import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/metadata_federation/aortem_auth0_get_metadata.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

void main() {
  group('aortemAuth0GetMetadata40', () {
    final auth0DomainUri = Uri.parse('https://example.auth0.com');

    test('returns metadata on success (200)', () async {
      final mockClient = MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer test-token');
        expect(
          request.url.toString(),
          '${auth0DomainUri.toString()}/metadata40',
        );
        return http.Response(
          jsonEncode({'key1': 'value1', 'key2': 'value2'}),
          200,
        );
      });

      final request = AortemAuth0GetMetadata40Request(
        accessToken: 'test-token',
      );
      final response = await aortemAuth0GetMetadata40(
        auth0DomainUri: auth0DomainUri,
        request: request,
        client: mockClient,
      );

      expect(response.metadata['key1'], equals('value1'));
      expect(response.metadata['key2'], equals('value2'));
    });

    test('throws on unauthorized (401)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      final request = AortemAuth0GetMetadata40Request(
        accessToken: 'invalid-token',
      );

      expect(
        () async => await aortemAuth0GetMetadata40(
          auth0DomainUri: auth0DomainUri,
          request: request,
          client: mockClient,
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Auth0 metadata fetch failed [401]'),
          ),
        ),
      );
    });

    test('throws ArgumentError for empty accessToken', () {
      expect(
        () => AortemAuth0GetMetadata40Request(accessToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on invalid JSON', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid JSON', 200);
      });

      final request = AortemAuth0GetMetadata40Request(
        accessToken: 'test-token',
      );

      expect(
        () async => await aortemAuth0GetMetadata40(
          auth0DomainUri: auth0DomainUri,
          request: request,
          client: mockClient,
        ),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to get metadata from Auth0'),
          ),
        ),
      );
    });
  });
}
