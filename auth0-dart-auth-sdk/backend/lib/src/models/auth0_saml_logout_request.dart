/// Represents the request payload for a SAML logout operation via Auth0.
///
/// This class allows you to send the necessary information to Auth0 to initiate
/// a SAML logout operation, including the client ID and optional parameters like
/// the redirect URL and federated logout behavior.
class Auth0SamlLogoutRequest {
  /// The client identifier for the Auth0 application.
  final String clientId;

  /// Optional: The URL to which the user will be redirected after logout.
  final String? returnTo;

  /// Optional: If true, logs the user out of federated SAML identity providers as well.
  final bool? federated;

  /// Constructs an [Auth0SamlLogoutRequest] with the required [clientId] and optional
  /// [returnTo] and [federated] parameters.
  Auth0SamlLogoutRequest({
    required this.clientId,
    this.returnTo,
    this.federated,
  }) {
    if (clientId.trim().isEmpty) {
      throw ArgumentError('Client ID must not be empty.');
    }
  }

  /// Converts this request into a map of query parameters for the SAML logout URL.
  ///
  /// The returned map contains the [client_id] parameter, and optionally, [returnTo] and
  /// [federated] if they are provided.
  Map<String, String> toQueryParams() {
    final params = <String, String>{'client_id': clientId};
    if (returnTo != null && returnTo!.trim().isNotEmpty) {
      params['returnTo'] = returnTo!;
    }
    if (federated == true) {
      params['federated'] = 'true';
    }
    return params;
  }
}
