import 'dart:convert';

import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_delete_authenticator_request_model.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import '../exceptions/aortem_auth0_delete_authenticator_exception.dart';
import '../models/aortem_auth0_delete_authenticator_response_model.dart';

/// Client for deleting MFA (Multi-Factor Authentication) authenticators from Auth0.
///
/// This client provides functionality to remove registered authenticators
/// (such as authenticator apps or security keys) from a user's Auth0 account.
///
/// Example usage:
/// ```dart
/// final client = AortemAuth0DeleteAuthenticatorClient(auth0Domain: 'your-domain.auth0.com');
/// final response = await client.deleteAuthenticator(request);
/// ```
class AortemAuth0DeleteAuthenticatorClient {
  /// The Auth0 domain used for API requests (e.g., 'your-domain.auth0.com').
  ///
  /// This should match the domain configured in your Auth0 tenant settings.
  final String auth0Domain;

  /// Creates a new instance of [AortemAuth0DeleteAuthenticatorClient].
  ///
  /// [auth0Domain] must be a valid Auth0 domain string in the format
  /// 'your-tenant.auth0.com'. This will be used to construct API endpoints.
  AortemAuth0DeleteAuthenticatorClient({required this.auth0Domain});

  /// Deletes a specific authenticator from the user's MFA configuration.
  ///
  /// This method makes an authenticated DELETE request to Auth0's MFA API
  /// to remove the specified authenticator. The operation requires both
  /// a valid access token and the ID of the authenticator to be deleted.
  ///
  /// [request] - Contains the required parameters:
  ///   - [accessToken]: A valid Auth0 access token with delete permissions
  ///   - [authenticatorId]: The ID of the authenticator to be removed
  ///
  /// Returns a [Future] that completes with an [AortemAuth0DeleteAuthenticatorResponse]
  /// indicating the result of the operation.
  ///
  /// Throws:
  /// - [ArgumentError] if required parameters are missing or empty
  /// - [AortemAuth0DeleteAuthenticatorException] if the API request fails
  /// - Other exceptions for network or JSON parsing errors
  ///
  /// Successful responses (status code 200 or 204) will return a response object
  /// with success=true. If the response body contains additional data,
  /// it will be parsed into the response object.
  Future<AortemAuth0DeleteAuthenticatorResponse> deleteAuthenticator(
    AortemAuth0DeleteAuthenticatorRequest request,
  ) async {
    // Validate required parameters
    if (request.accessToken.isEmpty || request.authenticatorId.isEmpty) {
      throw ArgumentError('Access token and authenticator ID are required.');
    }

    // Construct the API endpoint URL
    final url = Uri.parse(
      'https://$auth0Domain/mfa/authenticators/${request.authenticatorId}',
    );

    try {
      // Make authenticated DELETE request to Auth0 API
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer ${request.accessToken}'},
      );

      // Handle successful responses (200 OK or 204 No Content)
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isNotEmpty) {
          // Parse response body if present
          final Map<String, dynamic> responseJson = json.decode(response.body);
          return AortemAuth0DeleteAuthenticatorResponse.fromJson(responseJson);
        } else {
          // Return success response for empty responses
          return AortemAuth0DeleteAuthenticatorResponse(
            message: 'Authenticator deleted successfully.',
            success: true,
          );
        }
      } else {
        // Handle error responses
        throw AortemAuth0DeleteAuthenticatorException(
          'Failed to delete authenticator: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      // Handle unexpected errors
      throw AortemAuth0DeleteAuthenticatorException('Error: ${e.toString()}');
    }
  }
}
