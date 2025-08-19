/// Represents the request payload used for initiating a back-channel
/// login flow with Auth0.
///
/// This request is typically used in scenarios like CIBA (Client-Initiated
/// Backchannel Authentication) where the user is authenticated asynchronously
/// without interacting with a typical browser-based UI.
///
/// Includes required identifiers such as `clientId` and `loginHint`,
/// along with optional fields like `scope`, `acrValues`, and `bindingMessage`.
class Auth0BackChannelLoginRequest {
  /// The client identifier for the Auth0 application.
  final String clientId;

  /// A hint to identify the user, such as an email address or user ID.
  final String loginHint;

  /// Optional scope string that defines the access privileges of the tokens.
  final String? scope;

  /// Optional Authentication Context Class Reference values to specify
  /// desired authentication methods or strength.
  final String? acrValues;

  /// Optional message to be shown to the user during authentication.
  final String? bindingMessage;

  /// Constructs an [Auth0BackChannelLoginRequest] with the required
  /// [clientId] and [loginHint], and optionally includes [scope],
  /// [acrValues], and [bindingMessage].
  ///
  /// Throws an [ArgumentError] if `clientId` or `loginHint` are empty.
  Auth0BackChannelLoginRequest({
    required this.clientId,
    required this.loginHint,
    this.scope,
    this.acrValues,
    this.bindingMessage,
  }) {
    if (clientId.trim().isEmpty || loginHint.trim().isEmpty) {
      throw ArgumentError('Client ID and login hint cannot be empty');
    }
  }

  /// Converts this request object into a JSON-compatible map
  /// to be used in HTTP requests.
  Map<String, dynamic> toJson() => {
    'client_id': clientId,
    'login_hint': loginHint,
    if (scope != null) 'scope': scope,
    if (acrValues != null) 'acr_values': acrValues,
    if (bindingMessage != null) 'binding_message': bindingMessage,
  };
}
