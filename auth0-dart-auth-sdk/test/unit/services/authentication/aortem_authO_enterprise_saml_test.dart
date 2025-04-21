import 'package:auth0_dart_auth_sdk/src/exceptions/aortem_auth0_enterprise_saml_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_enterprise_saml_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_enterprise_saml_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/services/authentication/aortem-authO-enterprise-saml.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;
  late AortemAuth0EnterpriseSaml samlAuth;
  const domain = 'test.auth0.com';

  setUp(() {
    mockClient = MockClient();
    samlAuth = AortemAuth0EnterpriseSaml(
      domain: domain,
      httpClient: mockClient,
    );
  });

  tearDown(() {
    samlAuth.close();
  });

  group('Request Model', () {
    test('creates valid request with required fields', () {
      final request = AortemAuth0EnterpriseSamlRequest(
        connection: 'saml-enterprise',
        samlRequest: 'base64encoded_saml_request',
      );

      expect(request.toJson(), {
        'connection': 'saml-enterprise',
        'saml_request': 'base64encoded_saml_request',
      });
    });

    test('includes optional relayState when provided', () {
      final request = AortemAuth0EnterpriseSamlRequest(
        connection: 'saml-enterprise',
        samlRequest: 'base64encoded_saml_request',
        relayState: 'relay123',
      );

      expect(request.toJson(), {
        'connection': 'saml-enterprise',
        'saml_request': 'base64encoded_saml_request',
        'relay_state': 'relay123',
      });
    });

    test('throws ArgumentError for empty required fields', () {
      expect(
        () => AortemAuth0EnterpriseSamlRequest(
          connection: '',
          samlRequest: 'base64encoded_saml_request',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Response Model', () {
    test('parses successful response', () {
      final response = AortemAuth0EnterpriseSamlResponse.fromJson({
        'saml_response': 'base64encoded_saml_response',
        'relay_state': 'relay123',
      });

      expect(response.samlResponse, 'base64encoded_saml_response');
      expect(response.relayState, 'relay123');
    });

    test('handles response without relayState', () {
      final response = AortemAuth0EnterpriseSamlResponse.fromJson({
        'saml_response': 'base64encoded_saml_response',
      });

      expect(response.samlResponse, 'base64encoded_saml_response');
      expect(response.relayState, isNull);
    });

    test('throws FormatException for invalid response', () {
      expect(
        () => AortemAuth0EnterpriseSamlResponse.fromJson({
          'relay_state': 'relay123',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('Authentication', () {
    test('successful authentication returns SAML response', () async {
      when(mockClient.post(
        Uri.parse('https://$domain/samlp'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('''
        {
          "saml_response": "base64encoded_saml_response",
          "relay_state": "relay123"
        }
      ''', 200));

      final response = await samlAuth.authenticate(
        connection: 'saml-enterprise',
        samlRequest: 'base64encoded_saml_request',
      );

      expect(response.samlResponse, 'base64encoded_saml_response');
      expect(response.relayState, 'relay123');
    });

    test('throws exception for invalid SAML request', () async {
      when(mockClient.post(
        Uri.parse('https://$domain/samlp'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('''
        {
          "error": "invalid_saml_request",
          "error_description": "Invalid SAML request"
        }
      ''', 400));

      expect(
        () async => await samlAuth.authenticate(
          connection: 'saml-enterprise',
          samlRequest: 'invalid_saml_request',
        ),
        throwsA(isA<AortemAuth0EnterpriseSamlException>()),
      );
    });

    test('throws exception for network errors', () async {
      when(mockClient.post(
        Uri.parse('https://$domain/samlp'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenThrow(http.ClientException('Network error'));

      expect(
        () async => await samlAuth.authenticate(
          connection: 'saml-enterprise',
          samlRequest: 'base64encoded_saml_request',
        ),
        throwsA(isA<AortemAuth0EnterpriseSamlException>()),
      );
    });
  });
}
