import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_global_token_revocation_request.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_global_token_revocation_response.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for handling global token revocation via Auth0.
///
/// This class provides a method for revoking a global token using Auth0's
/// `/oauth/revoke` endpoint. The token is revoked, and the method returns
/// a response indicating whether the revocation was successful or not.
///
/// Example usage:
/// ```dart
/// final tokenRevocationService = AortemAuth0GlobalTokenRevocation(domain: 'your-domain.auth0.com');
/// final request = AortemAuth0GlobalTokenRevocationRequest(token: 'your-token');
/// try {
///   final response = await tokenRevocationService.revokeToken(request: request);
///   print('Token revocation successful: ${response.success}');
/// } catch (e) {
///   print('Token revocation failed: $e');
/// }
/// ```
class AortemAuth0GlobalTokenRevocation {
  /// The Auth0 domain.
  ///
  /// This is the domain for your Auth0 tenant, such as 'your-domain.auth0.com'.
  final String domain;

  /// Creates a new instance of [AortemAuth0GlobalTokenRevocation].
  ///
  /// Throws an [ArgumentError] if the provided domain is empty or only whitespace.
  AortemAuth0GlobalTokenRevocation({required this.domain}) {
    if (domain.trim().isEmpty) {
      throw ArgumentError('Auth0 domain must not be empty.');
    }
  }

  /// Revokes a global token via Auth0's /oauth/revoke endpoint.
  ///
  /// [request] contains the token revocation request data, which includes the token to be revoked.
  ///
  /// Returns an [AortemAuth0GlobalTokenRevocationResponse] indicating whether the revocation was successful.
  ///
  /// Throws an [Exception] if the revocation fails or the response is not successful.
  Future<AortemAuth0GlobalTokenRevocationResponse> revokeToken({
    required AortemAuth0GlobalTokenRevocationRequest request,
  }) async {
    final uri = Uri.https(domain, '/oauth/revoke');

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = request.toFormEncoded();

    // Send the token revocation request
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Success: return the revocation response
      return AortemAuth0GlobalTokenRevocationResponse(success: true);
    } else {
      // Failure: extract the error message from the response
      final errorBody =
          response.body.isNotEmpty ? response.body : 'No response body';
      throw Exception(
        'Failed to revoke token. Status code: ${response.statusCode}. Body: $errorBody',
      );
    }
  }
}
