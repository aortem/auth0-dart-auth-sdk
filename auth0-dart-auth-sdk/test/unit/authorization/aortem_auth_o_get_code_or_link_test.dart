import 'package:auth_o_dart_auth_sdk/src/models/aortem_auth_o_get_code_or_link_request.dart';
import 'package:auth_o_dart_auth_sdk/src/authorization/aortem_auth_o_get_code_or_link.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:ds_tools_testing/ds_tools_testing.dart';

// Create a mock client to simulate the HTTP requests
class MockClient extends Mock implements http.Client {}

void main() {
  group('AortemAuth0GetCodeOrLink', () {
    late AortemAuth0GetCodeOrLink aortemAuth0GetCodeOrLink;

    setUp(() {
      // Initialize the mock client and the class to test
      aortemAuth0GetCodeOrLink = AortemAuth0GetCodeOrLink(
        domain: 'your-tenant.auth0.com',
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
        expect(
          () => aortemAuth0GetCodeOrLink.sendCodeOrLink(request: request),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
