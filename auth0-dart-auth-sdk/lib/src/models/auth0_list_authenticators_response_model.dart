import 'package:auth0_dart_auth_sdk/src/models/auth0_list_authenticators_model.dart';

/// Represents the response from listing a user's MFA (Multi-Factor Authentication) authenticators.
///
/// This model contains the list of authenticators registered for a user in Auth0,
/// which may include various types of MFA methods such as:
/// - Authenticator apps (TOTP)
/// - SMS verification
/// - Biometric authenticators
/// - Security keys (WebAuthn)
///
/// The response is typically returned from Auth0's MFA authenticators list endpoint.
class Auth0ListAuthenticatorsResponse {
  /// The list of authenticators registered for the user.
  ///
  /// Each authenticator contains details about the MFA method, including:
  /// - The authenticator ID
  /// - The type of authenticator
  /// - Creation and last used timestamps
  /// - Other method-specific details
  final List<Auth0Authenticator> authenticators;

  /// Creates a new [Auth0ListAuthenticatorsResponse] instance.
  ///
  /// [authenticators] must be a non-null list of [Auth0Authenticator] objects
  /// representing the user's registered MFA methods.
  Auth0ListAuthenticatorsResponse({required this.authenticators});

  /// Creates an [Auth0ListAuthenticatorsResponse] from a JSON map.
  ///
  /// The JSON structure should match the format returned by Auth0's MFA API.
  /// Expected format:
  /// ```json
  /// {
  ///   "authenticators": [
  ///     {
  ///       "id": "auth_123",
  ///       "type": "totp",
  ///       "name": "Google Authenticator",
  ///       ...
  ///     },
  ///     ...
  ///   ]
  /// }
  /// ```
  ///
  /// Throws:
  /// - [FormatException] if the JSON structure is invalid
  /// - [TypeError] if the JSON types don't match expected types
  factory Auth0ListAuthenticatorsResponse.fromJson(Map<String, dynamic> json) {
    return Auth0ListAuthenticatorsResponse(
      authenticators: (json['authenticators'] as List)
          .map((e) => Auth0Authenticator.fromJson(e))
          .toList(),
    );
  }
}
