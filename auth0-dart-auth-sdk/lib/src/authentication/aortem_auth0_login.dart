import 'dart:async';
import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Exception thrown when authentication fails in [AortemAuth0LoginService].
///
/// Provides detailed information about the failure including:
/// - A human-readable error [message]
/// - The HTTP [statusCode] if available from the response
/// - An Auth0-specific [errorCode] if provided in the error response
class AortemAuth0LoginException implements Exception {
  /// Descriptive message explaining the authentication failure
  final String message;

  /// HTTP status code from the failed response (if available)
  final int? statusCode;

  /// Auth0-specific error code from the response (if available)
  final String? errorCode;

  /// Creates an authentication exception with the given details
  AortemAuth0LoginException(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() =>
      'AortemAuth0LoginException: $message'
      '${statusCode != null ? ' (Status: $statusCode)' : ''}'
      '${errorCode != null ? ' [Code: $errorCode]' : ''}';
}

/// Encapsulates all parameters needed for an Auth0 authentication request.
///
/// Includes both required parameters for standard authentication flow
/// and optional parameters for extended functionality.
class AortemAuth0LoginRequest {
  /// The user's identifier (username or email)
  final String username;

  /// The user's password
  final String password;

  /// The Auth0 connection to use (e.g., 'Username-Password-Authentication')
  final String connection;

  /// The client ID of your Auth0 application
  final String clientId;

  /// The scope of the access request (defaults to 'openid profile email')
  final String? scope;

  /// The audience for the access token (typically your API identifier)
  final String? audience;

  /// Additional parameters to include in the authentication request
  final Map<String, String>? additionalParameters;

  /// Creates an authentication request with the specified parameters
  AortemAuth0LoginRequest({
    required this.username,
    required this.password,
    required this.connection,
    required this.clientId,
    this.scope,
    this.audience,
    this.additionalParameters,
  });

  /// Converts the request to a JSON map suitable for transmission to Auth0
  Map<String, dynamic> toJson() {
    final json = {
      'username': username,
      'password': password,
      'connection': connection,
      'client_id': clientId,
      'scope': scope ?? 'openid profile email',
      'audience': audience,
    };

    if (additionalParameters != null) {
      json.addAll(additionalParameters!);
    }

    return json;
  }
}

/// Contains all tokens and metadata returned from a successful Auth0 authentication.
class AortemAuth0LoginResponse {
  /// The access token used to authenticate API requests
  final String accessToken;

  /// The refresh token used to obtain new access tokens
  final String? refreshToken;

  /// The ID token containing user information (JWT)
  final String? idToken;

  /// The type of token returned (typically 'Bearer')
  final String tokenType;

  /// The lifetime in seconds of the access token
  final int? expiresIn;

  /// Any additional data returned in the response that isn't part of standard fields
  final Map<String, dynamic>? additionalData;

  /// Creates a response object from the authentication tokens
  AortemAuth0LoginResponse({
    required this.accessToken,
    this.refreshToken,
    this.idToken,
    required this.tokenType,
    this.expiresIn,
    this.additionalData,
  });

  /// Parses a JSON response from Auth0 into an [AortemAuth0LoginResponse] object
  factory AortemAuth0LoginResponse.fromJson(Map<String, dynamic> json) {
    return AortemAuth0LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      idToken: json['id_token'] as String?,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int?,
      additionalData: _extractAdditionalData(json),
    );
  }

  /// Extracts any fields from the response that aren't part of standard token response
  static Map<String, dynamic>? _extractAdditionalData(
    Map<String, dynamic> json,
  ) {
    final knownFields = {
      'access_token',
      'refresh_token',
      'id_token',
      'token_type',
      'expires_in',
    };
    return Map.fromEntries(
      json.entries.where((e) => !knownFields.contains(e.key)),
    );
  }
}

/// Service for authenticating users with Auth0's OAuth 2.0 token endpoint.
///
/// Handles the complete authentication flow including:
/// - Sending credentials to Auth0
/// - Parsing successful responses
/// - Handling and classifying errors
/// - Managing network timeouts
class AortemAuth0LoginService {
  /// The Auth0 domain (e.g., 'your-domain.auth0.com')
  final String auth0Domain;

  /// The HTTP client used for making requests
  final http.Client _client;

  /// The maximum duration to wait for a response
  final Duration requestTimeout;

  /// Creates an authentication service instance
  ///
  /// Parameters:
  ///   - [auth0Domain]: Your Auth0 domain (required)
  ///   - [client]: Optional custom HTTP client (for testing or customization)
  ///   - [requestTimeout]: Maximum wait time for requests (default: 30 seconds)
  AortemAuth0LoginService({
    required this.auth0Domain,
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();

  /// Authenticates a user with Auth0 using the provided credentials
  ///
  /// Parameters:
  ///   - [request]: The authentication request containing user credentials
  ///
  /// Returns:
  ///   A [Future] that resolves to an [AortemAuth0LoginResponse] on success
  ///
  /// Throws:
  ///   - [AortemAuth0LoginException] for authentication failures
  ///   - [TimeoutException] if the request times out
  ///   - [FormatException] for malformed responses
  Future<AortemAuth0LoginResponse> login(
    AortemAuth0LoginRequest request,
  ) async {
    try {
      final url = Uri.parse('https://$auth0Domain/oauth/token');

      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(requestTimeout);

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return AortemAuth0LoginResponse.fromJson(responseBody);
      } else {
        throw _parseErrorResponse(response.statusCode, responseBody);
      }
    } on TimeoutException {
      throw AortemAuth0LoginException('Request timed out');
    } on FormatException {
      throw AortemAuth0LoginException('Invalid server response format');
    } on http.ClientException catch (e) {
      // Handle ClientException without statusCode access
      throw AortemAuth0LoginException('Network error: ${e.toString()}');
    } catch (e) {
      throw AortemAuth0LoginException('Unexpected error: ${e.toString()}');
    }
  }

  /// Parses error responses from Auth0 into standardized exceptions
  AortemAuth0LoginException _parseErrorResponse(
    int statusCode,
    Map<String, dynamic> responseBody,
  ) {
    final error = responseBody['error']?.toString() ?? 'unknown_error';
    final description =
        responseBody['error_description']?.toString() ??
        'Authentication failed';

    return AortemAuth0LoginException(
      description,
      statusCode: statusCode,
      errorCode: error,
    );
  }

  /// Cleans up resources used by the service
  ///
  /// Important: Call this when the service is no longer needed,
  /// especially if you provided a custom HTTP client.
  void dispose() {
    _client.close();
  }
}
