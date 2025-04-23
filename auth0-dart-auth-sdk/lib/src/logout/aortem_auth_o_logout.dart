import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_logout_request_model.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth_o_logout_response_model.dart';

/// A service for handling Auth0 user logout.
///
/// This class provides a method to generate a logout URL for Auth0. The URL can be used
/// to redirect the user to Auth0's logout endpoint, where they will be logged out
/// from the current session.
///
/// Example usage:
/// ```dart
/// final logoutService = AortemAuth0Logout(auth0Domain: 'your-domain.auth0.com');
/// final request = AortemAuth0LogoutRequest(clientId: 'your-client-id');
/// final response = logoutService.generateLogoutUrl(request);
/// print('Logout URL: ${response.logoutUrl}');
/// ```
class AortemAuth0Logout {
  /// The Auth0 domain.
  ///
  /// This is the domain for your Auth0 tenant, such as 'your-domain.auth0.com'.
  final String auth0Domain;

  /// Creates a new instance of [AortemAuth0Logout].
  ///
  /// Throws an [ArgumentError] if the provided domain is empty or only whitespace.
  AortemAuth0Logout({required this.auth0Domain});

  /// Generates a logout URL for Auth0.
  ///
  /// This method creates a URL to the Auth0 logout endpoint (`/v2/logout`) with the
  /// appropriate query parameters.
  ///
  /// [request] contains the necessary data for generating the logout URL, including
  /// the `clientId` (which is required) and optional parameters such as `returnTo`
  /// (a URL to redirect the user to after logout) and `federated` (a flag to specify if
  /// federated logout should be performed).
  ///
  /// Returns an [AortemAuth0LogoutResponse] containing the generated logout URL.
  ///
  /// Throws an [ArgumentError] if `clientId` is not provided.
  AortemAuth0LogoutResponse generateLogoutUrl(
      AortemAuth0LogoutRequest request) {
    // Validate the required parameter: clientId
    if (request.clientId.isEmpty) {
      throw ArgumentError('clientId is required for logout.');
    }

    // Construct the base URL for the logout endpoint
    final baseUri = Uri.parse('https://$auth0Domain/v2/logout');

    // Set up query parameters for the logout URL
    final queryParams = {
      'client_id': request.clientId,
      if (request.returnTo != null) 'returnTo': request.returnTo!,
      if (request.federated == true) 'federated': ''
    };

    // Replace query parameters in the base URI
    final logoutUri = baseUri.replace(queryParameters: queryParams);

    // Return the generated logout URL as part of the response
    return AortemAuth0LogoutResponse(logoutUrl: logoutUri.toString());
  }
}
