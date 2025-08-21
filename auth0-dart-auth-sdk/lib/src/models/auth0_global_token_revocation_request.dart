/// Represents a request to revoke a token globally across an Auth0 tenant
class Auth0GlobalTokenRevocationRequest {
  /// The token to be revoked
  final String token;

  /// The client ID of the application requesting token revocation
  final String clientId;

  /// Optional hint about the type of token being revoked (e.g. 'access_token', 'refresh_token')
  final String? tokenTypeHint;

  /// Creates a new token revocation request
  ///
  /// [token] - The token to revoke
  /// [clientId] - The client ID of the requesting application
  /// [tokenTypeHint] - Optional hint about token type
  ///
  /// Throws [ArgumentError] if token or clientId are empty
  Auth0GlobalTokenRevocationRequest({
    required this.token,
    required this.clientId,
    this.tokenTypeHint,
  }) {
    if (token.trim().isEmpty) {
      throw ArgumentError('Token must not be empty.');
    }
    if (clientId.trim().isEmpty) {
      throw ArgumentError('Client ID must not be empty.');
    }
  }

  /// Converts the request into form-encoded data for the API request
  ///
  /// Returns a Map containing the request parameters in the correct format
  Map<String, String> toFormEncoded() {
    final data = {'token': token, 'client_id': clientId};
    if (tokenTypeHint != null) {
      data['token_type_hint'] = tokenTypeHint!;
    }
    return data;
  }
}
