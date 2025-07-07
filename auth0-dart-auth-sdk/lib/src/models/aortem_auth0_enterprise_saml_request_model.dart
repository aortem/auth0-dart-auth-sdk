/// Represents the request payload used for enterprise SAML authentication
/// via Auth0.
///
/// This request is typically used for initiating SAML-based authentication
/// through an enterprise connection (e.g., Active Directory, LDAP).
///
/// It includes the required `connection` (enterprise connection name) and
/// `samlRequest` (base64-encoded SAML authentication request), along with
/// an optional `relayState` to maintain state between the request and response.
class AortemAuth0EnterpriseSamlRequest {
  /// The name of the Auth0 enterprise connection (e.g., "saml-enterprise").
  final String connection;

  /// The base64-encoded SAML authentication request sent to the IdP.
  final String samlRequest;

  /// Optional relay state to preserve the state between the request and response.
  final String? relayState;

  /// Constructs an [AortemAuth0EnterpriseSamlRequest] with the given [connection],
  /// [samlRequest], and optionally a [relayState].
  ///
  /// Throws an [ArgumentError] if `connection` or `samlRequest` are empty.
  AortemAuth0EnterpriseSamlRequest({
    required this.connection,
    required this.samlRequest,
    this.relayState,
  }) {
    if (connection.trim().isEmpty || samlRequest.trim().isEmpty) {
      throw ArgumentError('Connection and SAML request cannot be empty');
    }
  }

  /// Converts this request object into a JSON-compatible map
  /// to be used in HTTP requests.
  Map<String, dynamic> toJson() => {
        'connection': connection,
        'saml_request': samlRequest,
        if (relayState != null) 'relay_state': relayState,
      };
}
