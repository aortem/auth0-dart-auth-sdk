import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_get_code_or_link_request.dart';
import 'package:auth0_dart_auth_sdk/src/services/authorization/aortem-authO-get-code-or-link.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';

// Create a mock client to simulate the HTTP requests
class MockClient extends Mock implements http.Client {}

void main() {
  group('AortemAuth0GetCodeOrLink', () {
    late MockClient mockClient;
    late AortemAuth0GetCodeOrLink aortemAuth0GetCodeOrLink;

    setUp(() {
      // Initialize the mock client and the class to test
      mockClient = MockClient();
      aortemAuth0GetCodeOrLink =
          AortemAuth0GetCodeOrLink(domain: 'your-tenant.auth0.com');
    });

    test('sendCodeOrLink should return success when statusCode is 200',
        () async {
      final request = AortemAuth0GetCodeOrLinkRequest(
        clientId: 'your-client-id',
        connection: 'email',
        email: 'user@example.com',
      );

      // Mock the HTTP response
      when(mockClient.post(
        Uri.https('your-tenant.auth0.com', '/passwordless/start'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 200));

      // Call the method
      final response =
          await aortemAuth0GetCodeOrLink.sendCodeOrLink(request: request);

      // Check the expected result
      expect(response.success, true);
      expect(response.message, 'Code or link successfully sent.');
    });

    test('sendCodeOrLink should throw an exception when statusCode is not 200',
        () async {
      final request = AortemAuth0GetCodeOrLinkRequest(
        clientId: 'your-client-id',
        connection: 'email',
        email: 'user@example.com',
      );

      // Mock the HTTP response with an error status code
      when(mockClient.post(
        Uri.https('your-tenant.auth0.com', '/passwordless/start'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 400));

      // Call the method and expect an exception
      expect(
        () async =>
            await aortemAuth0GetCodeOrLink.sendCodeOrLink(request: request),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'sendCodeOrLink should throw an exception for invalid request parameters',
        () {
      final request = AortemAuth0GetCodeOrLinkRequest(
        clientId: '',
        connection: 'email',
        email: 'user@example.com',
      );

      // Expecting ArgumentError due to empty clientId
      expect(() => aortemAuth0GetCodeOrLink.sendCodeOrLink(request: request),
          throwsA(isA<ArgumentError>()));
    });
  });
}
