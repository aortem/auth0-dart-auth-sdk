/// A request object for obtaining tokens from Auth0 using various OAuth 2.0 flows.
///
/// This class encapsulates all possible parameters that can be sent to Auth0's
/// `/oauth/token` endpoint to obtain an access token, ID token, and/or refresh token.
/// The required fields vary depending on the OAuth 2.0 grant type being used.
///
/// Supported grant types (specified in [grantType]):
/// - 'authorization_code' (Authorization Code Flow)
/// - 'password' (Resource Owner Password Flow)
/// - 'client_credentials' (Client Credentials Flow)
/// - 'refresh_token' (Refresh Token Flow)
/// - 'urn:ietf:params:oauth:grant-type:device_code' (Device Code Flow)
///
/// Example usage:
/// ```dart
/// // Authorization Code Flow
/// final request = Auth0GetTokenRequest(
///   grantType: 'authorization_code',
///   clientId: 'your_client_id',
///   clientSecret: 'your_client_secret',
///   code: 'authorization_code_from_callback',
///   redirectUri: 'https://your.app/callback',
/// );
///
/// // Password Realm Flow
/// final request = Auth0GetTokenRequest(
///   grantType: 'password',
///   clientId: 'your_client_id',
///   username: 'user@example.com',
///   password: 'user_password',
///   audience: 'your_api_audience',
/// );
/// ```
class Auth0GetTokenRequest {
  /// The OAuth 2.0 grant type being used.
  ///
  /// Required for all requests. Common values include:
  /// - 'authorization_code'
  /// - 'password'
  /// - 'client_credentials'
  /// - 'refresh_token'
  /// - 'urn:ietf:params:oauth:grant-type:device_code'
  final String grantType;

  /// The client ID of your Auth0 application.
  ///
  /// Required for all requests.
  final String clientId;

  /// The client secret of your Auth0 application.
  ///
  /// Required for confidential clients in most flows except when using PKCE.
  final String? clientSecret;

  /// The authorization code received from Auth0 (Authorization Code Flow).
  ///
  /// Required when [grantType] is 'authorization_code'.
  final String? code;

  /// The redirect URI used in the authorization request (Authorization Code Flow).
  ///
  /// Required when [grantType] is 'authorization_code' and must match the URI
  /// registered in your Auth0 application settings.
  final String? redirectUri;

  /// The end-user's username (Resource Owner Password Flow).
  ///
  /// Required when [grantType] is 'password'.
  final String? username;

  /// The end-user's password (Resource Owner Password Flow).
  ///
  /// Required when [grantType] is 'password'.
  final String? password;

  /// The audience of the API you want to access.
  ///
  /// Used to specify the target API for access tokens. Required for some grant types
  /// when requesting access tokens for specific APIs.
  final String? audience;

  /// The scope of the access request.
  ///
  /// A space-separated list of permissions being requested. Common values include:
  /// - 'openid' (for ID tokens)
  /// - 'profile'
  /// - 'email'
  /// - 'offline_access' (for refresh tokens)
  final String? scope;

  /// The device code from the device authorization flow.
  ///
  /// Required when [grantType] is 'urn:ietf:params:oauth:grant-type:device_code'.
  final String? deviceCode;

  /// The refresh token previously issued by Auth0.
  ///
  /// Required when [grantType] is 'refresh_token'.
  final String? refreshToken;

  /// Additional parameters to include in the token request.
  ///
  /// This map can be used to send custom parameters to Auth0 that aren't covered
  /// by the standard properties. All key-value pairs will be added to the request.
  final Map<String, dynamic>? additionalParameters;

  /// Creates a new token request instance.
  ///
  /// [grantType] and [clientId] are required for all requests. Other parameters
  /// are required or optional depending on the grant type being used.
  Auth0GetTokenRequest({
    required this.grantType,
    required this.clientId,
    this.clientSecret,
    this.code,
    this.redirectUri,
    this.username,
    this.password,
    this.audience,
    this.scope,
    this.deviceCode,
    this.refreshToken,
    this.additionalParameters,
  });

  /// Converts this request object to a JSON map suitable for sending to Auth0.
  ///
  /// The resulting map includes all non-null properties and can be sent directly
  /// as the body of a POST request to the `/oauth/token` endpoint.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'grant_type': grantType,
      'client_id': clientId,
      if (clientSecret != null) 'client_secret': clientSecret,
      if (code != null) 'code': code,
      if (redirectUri != null) 'redirect_uri': redirectUri,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (audience != null) 'audience': audience,
      if (scope != null) 'scope': scope,
      if (deviceCode != null) 'device_code': deviceCode,
      if (refreshToken != null) 'refresh_token': refreshToken,
    };

    if (additionalParameters != null) {
      json.addAll(additionalParameters!);
    }

    return json;
  }
}
