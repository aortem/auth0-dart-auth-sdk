import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_back_channel_login_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_back_channel_login_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/authentication/aortem_auth_o_backchannel_login.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;
  late AortemAuth0BackChannelLogin backChannelLogin;
  const domain = 'test.auth0.com';

  setUp(() {
    mockClient = MockClient();
    backChannelLogin = AortemAuth0BackChannelLogin(
      domain: domain,
      httpClient: mockClient,
    );
  });

  tearDown(() {
    backChannelLogin.close();
  });

  group('Request Model', () {
    test('creates valid request with required fields', () {
      final request = AortemAuth0BackChannelLoginRequest(
        clientId: 'test_client_id',
        loginHint: 'user@example.com',
      );

      expect(request.toJson(), {
        'client_id': 'test_client_id',
        'login_hint': 'user@example.com',
      });
    });

    test('includes optional fields when provided', () {
      final request = AortemAuth0BackChannelLoginRequest(
        clientId: 'test_client_id',
        loginHint: 'user@example.com',
        scope: 'openid profile',
        acrValues: 'acr1',
        bindingMessage: 'Please authenticate',
      );

      expect(request.toJson(), {
        'client_id': 'test_client_id',
        'login_hint': 'user@example.com',
        'scope': 'openid profile',
        'acr_values': 'acr1',
        'binding_message': 'Please authenticate',
      });
    });

    test('throws ArgumentError for empty required fields', () {
      expect(
        () => AortemAuth0BackChannelLoginRequest(
          clientId: '',
          loginHint: 'user@example.com',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Response Model', () {
    test('parses successful response', () {
      final response = AortemAuth0BackChannelLoginResponse.fromJson({
        'auth_req_id': 'auth_req_123',
        'expires_in': 300,
        'interval': 5,
      });

      expect(response.authReqId, 'auth_req_123');
      expect(response.expiresIn, 300);
      expect(response.interval, 5);
    });

    test('handles response without interval', () {
      final response = AortemAuth0BackChannelLoginResponse.fromJson({
        'auth_req_id': 'auth_req_123',
        'expires_in': 300,
      });

      expect(response.authReqId, 'auth_req_123');
      expect(response.interval, isNull);
    });

    test('throws FormatException for invalid response', () {
      expect(
        () => AortemAuth0BackChannelLoginResponse.fromJson({'expires_in': 300}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
