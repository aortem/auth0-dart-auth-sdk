import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_logout_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_logout_response_model.dart';
import 'package:auth0_dart_auth_sdk/src/logout/aortem_auth_o_logout.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  // Define constants at the top level of the test file
  const testDomain = 'test-domain.auth0.com';
  const testClientId = 'test_client_id_123';
  const testReturnTo = 'https://example.com/logout-callback';
  const testLogoutUrl = 'https://test-domain.auth0.com/v2/logout?client_id=123';

  group('AortemAuth0Logout', () {
    late AortemAuth0Logout logoutService;

    setUp(() {
      logoutService = AortemAuth0Logout(auth0Domain: testDomain);
    });

    test('throws when auth0Domain is empty', () {
      expect(
        () => AortemAuth0Logout(auth0Domain: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    group('generateLogoutUrl', () {
      test('generates basic logout URL with clientId', () {
        final request = AortemAuth0LogoutRequest(clientId: testClientId);
        final response = logoutService.generateLogoutUrl(request);

        expect(response.logoutUrl, contains('https://$testDomain/v2/logout'));
        expect(response.logoutUrl, contains('client_id=$testClientId'));
        expect(response.logoutUrl, isNot(contains('returnTo')));
        expect(response.logoutUrl, isNot(contains('federated')));
      });

      test('includes returnTo when provided', () {
        final request = AortemAuth0LogoutRequest(
          clientId: testClientId,
          returnTo: testReturnTo,
        );
        final response = logoutService.generateLogoutUrl(request);

        expect(response.logoutUrl, contains('returnTo=$testReturnTo'));
      });

      test('includes federated param when true', () {
        final request = AortemAuth0LogoutRequest(
          clientId: testClientId,
          federated: true,
        );
        final response = logoutService.generateLogoutUrl(request);

        expect(response.logoutUrl, contains('federated='));
      });

      test('throws when clientId is empty', () {
        final request = AortemAuth0LogoutRequest(clientId: '');
        expect(
          () => logoutService.generateLogoutUrl(request),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });

  group('AortemAuth0LogoutRequest', () {
    test('throws when clientId is empty', () {
      expect(
        () => AortemAuth0LogoutRequest(clientId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('converts to query params correctly', () {
      final request = AortemAuth0LogoutRequest(
        clientId: testClientId,
        returnTo: testReturnTo,
        federated: true,
      );

      final params = request.toQueryParams();

      expect(params['client_id'], testClientId);
      expect(params['returnTo'], testReturnTo);
      expect(params.containsKey('federated'), isTrue);
    });

    test('converts to JSON correctly', () {
      final request = AortemAuth0LogoutRequest(
        clientId: testClientId,
        returnTo: testReturnTo,
        federated: true,
      );

      final json = request.toJson();

      expect(json['client_id'], testClientId);
      expect(json['return_to'], testReturnTo);
      expect(json['federated'], true);
    });
  });

  group('AortemAuth0LogoutResponse', () {
    test('throws when logoutUrl is empty', () {
      expect(
        () => AortemAuth0LogoutResponse(logoutUrl: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('creates from JSON correctly', () {
      final response = AortemAuth0LogoutResponse.fromJson({
        'logout_url': testLogoutUrl,
      });

      expect(response.logoutUrl, testLogoutUrl);
    });

    test('converts to JSON correctly', () {
      final response = AortemAuth0LogoutResponse(logoutUrl: testLogoutUrl);
      final json = response.toJson();

      expect(json['logout_url'], testLogoutUrl);
    });

    test('toString() returns correct representation', () {
      final response = AortemAuth0LogoutResponse(logoutUrl: testLogoutUrl);
      expect(response.toString(), contains('AortemAuth0LogoutResponse'));
      expect(response.toString(), contains(testLogoutUrl));
    });
  });
}
