import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_database_ldap_passive_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_database_ldap_passive_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/authentication/aortem_auth_o_database_ldap_passive.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;
  late AortemAuth0DatabaseAdLdapPassive passiveAuth;
  const domain = 'test.auth0.com';
  const clientId = 'test_client_id';

  setUp(() {
    mockClient = MockClient();
    passiveAuth = AortemAuth0DatabaseAdLdapPassive(
      domain: domain,
      clientId: clientId,
      httpClient: mockClient,
    );
  });

  tearDown(() {
    passiveAuth.close();
  });

  group('Request Model', () {
    test('creates valid request with required fields', () {
      final request = AortemAuth0DatabaseAdLdapPassiveRequest(
        username: 'user@test.com',
        password: 'password123',
        connection: 'Username-Password-Authentication',
      );

      expect(request.toJson(), {
        'username': 'user@test.com',
        'password': 'password123',
        'connection': 'Username-Password-Authentication',
      });
    });

    test('includes optional fields when provided', () {
      final request = AortemAuth0DatabaseAdLdapPassiveRequest(
        username: 'user@test.com',
        password: 'password123',
        connection: 'active-directory',
        scope: 'openid profile',
        audience: 'api://default',
      );

      expect(request.toJson(), {
        'username': 'user@test.com',
        'password': 'password123',
        'connection': 'active-directory',
        'scope': 'openid profile',
        'audience': 'api://default',
      });
    });

    test('throws ArgumentError for empty required fields', () {
      expect(
        () => AortemAuth0DatabaseAdLdapPassiveRequest(
          username: '',
          password: 'password123',
          connection: 'ldap',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Response Model', () {
    test('parses successful response', () {
      final response = AortemAuth0DatabaseAdLdapPassiveResponse.fromJson({
        'access_token': 'test_access_token',
        'id_token': 'test_id_token',
        'token_type': 'Bearer',
        'refresh_token': 'test_refresh_token',
        'expires_in': 3600,
      });

      expect(response.accessToken, 'test_access_token');
      expect(response.idToken, 'test_id_token');
      expect(response.tokenType, 'Bearer');
      expect(response.refreshToken, 'test_refresh_token');
      expect(response.expiresIn, 3600);
    });

    test('handles response without optional fields', () {
      final response = AortemAuth0DatabaseAdLdapPassiveResponse.fromJson({
        'access_token': 'test_access_token',
        'id_token': 'test_id_token',
        'token_type': 'Bearer',
      });

      expect(response.accessToken, 'test_access_token');
      expect(response.refreshToken, isNull);
      expect(response.expiresIn, isNull);
    });

    test('throws FormatException for invalid response', () {
      expect(
        () => AortemAuth0DatabaseAdLdapPassiveResponse.fromJson({
          'token_type': 'Bearer',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
