/// Represents the response received after completing the enterprise SAML
/// authentication flow via Auth0.
///
/// This response typically contains the `samlResponse` to be consumed by
/// the service provider (SP) for establishing the user's identity, and an
/// optional `relayState` which may be used to maintain the state between
/// the request and response phases.
class AortemAuth0EnterpriseSamlResponse {
  /// The SAML response to be used by the service provider to authenticate the user.
  final String samlResponse;

  /// Optional relay state returned from the authentication flow.
  ///
  /// The relay state can be used to maintain the state or context between
  /// the request and response during the authentication flow.
  final String? relayState;

  /// Constructs an [AortemAuth0EnterpriseSamlResponse] with the given [samlResponse]
  /// and optional [relayState].
  AortemAuth0EnterpriseSamlResponse({
    required this.samlResponse,
    this.relayState,
  });

  /// Creates an instance of [AortemAuth0EnterpriseSamlResponse] from a JSON map.
  ///
  /// Throws a [FormatException] if the required field `saml_response` is missing.
  factory AortemAuth0EnterpriseSamlResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['saml_response'] == null) {
      throw FormatException(
          'Missing required field saml_response in Auth0 response');
    }

    return AortemAuth0EnterpriseSamlResponse(
      samlResponse: json['saml_response'] as String,
      relayState: json['relay_state'] as String?,
    );
  }
}
