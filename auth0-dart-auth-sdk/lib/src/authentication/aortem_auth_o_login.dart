import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Exception thrown when login fails in [AortemAuth0LoginService].
///
/// Contains details about the authentication failure that can be used
/// to inform the user or for debugging purposes.
class AortemAuth0LoginException implements Exception {
  /// A human-readable message describing the login failure.
  final String message;

  /// Creates an instance of [AortemAuth0LoginException] with the given [message].
  AortemAuth0LoginException(this.message);

  @override
  String toString() => 'AortemAuth0LoginException: $message';
}

/// Represents a login request payload for Auth0 authentication.
///
/// This class encapsulates all required and optional parameters needed
/// to authenticate a user with Auth0's OAuth token endpoint.
class AortemAuth0LoginRequest {
  /// The user's username or email address.
  final String username;

  /// The user's password.
  final String password;

  /// The Auth0 connection to use for authentication.
  ///
  /// This typically specifies the identity provider (e.g., 'Username-Password-Authentication').
  final String connection;

  /// The client ID of the Auth0 application.
  final String clientId;

  /// The scope of the access request (optional).
  ///
  /// Defaults to 'openid profile email' if not specified.
  final String? scope;

  /// The audience for the access token (optional).
  ///
  /// This is typically the API identifier that the token will be used to access.
  final String? audience;

  /// Creates an instance of [AortemAuth0LoginRequest].
  AortemAuth0LoginRequest({
    required this.username,
    required this.password,
    required this.connection,
    required this.clientId,
    this.scope,
    this.audience,
  });

  /// Converts the request data to a JSON map suitable for HTTP transmission.
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'connection': connection,
        'client_id': clientId,
        'scope': scope ?? 'openid profile email',
        'audience': audience,
      };
}

/// Represents a successful login response containing authentication tokens.
///
/// This class parses and holds the tokens returned by Auth0's OAuth token endpoint
/// after a successful authentication.
class AortemAuth0LoginResponse {
  /// The access token used to authenticate API requests.
  final String accessToken;

  /// The refresh token used to obtain new access tokens (optional).
  ///
  /// May not be present depending on Auth0 configuration.
  final String? refreshToken;

  /// The ID token containing user information (optional).
  ///
  /// Present when using OpenID Connect.
  final String? idToken;

  /// The type of token returned (typically 'Bearer').
  final String tokenType;

  /// The lifetime in seconds of the access token (optional).
  final int? expiresIn;

  /// Creates an instance of [AortemAuth0LoginResponse].
  AortemAuth0LoginResponse({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
    required this.tokenType,
    this.expiresIn,
  });

  /// Parses a JSON response from Auth0 into an [AortemAuth0LoginResponse] instance.
  ///
  /// Throws if the required fields are not present in the JSON.
  factory AortemAuth0LoginResponse.fromJson(Map<String, dynamic> json) {
    return AortemAuth0LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      idToken: json['id_token'] as String?,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int?,
    );
  }
}

/// Service for handling user authentication with Auth0.
///
/// This class provides methods to authenticate users using Auth0's
/// OAuth token endpoint and returns the resulting tokens.
class AortemAuth0LoginService {
  /// The Auth0 domain (e.g., 'your-domain.auth0.com').
  ///
  /// This is used to construct the OAuth token endpoint URL.
  final String auth0Domain;

  /// Creates an instance of [AortemAuth0LoginService] with the given [auth0Domain].
  AortemAuth0LoginService({required this.auth0Domain});

  /// Authenticates a user with Auth0 using the provided credentials.
  ///
  /// Sends a request to Auth0's OAuth token endpoint and returns the tokens
  /// if authentication is successful.
  ///
  /// Parameters:
  ///   - [request]: The login request containing user credentials and configuration
  ///
  /// Returns:
  ///   A [Future] that completes with an [AortemAuth0LoginResponse] containing
  ///   the authentication tokens on success.
  ///
  /// Throws:
  ///   - [AortemAuth0LoginException] if the authentication fails
  ///   - [http.ClientException] if there's a network or HTTP protocol error
  ///   - [FormatException] if the response body contains invalid JSON
  Future<AortemAuth0LoginResponse> login(
      AortemAuth0LoginRequest request) async {
    final url = Uri.parse('https://$auth0Domain/oauth/token');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AortemAuth0LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw AortemAuth0LoginException('Login failed: ${response.body}');
    }
  }
}
