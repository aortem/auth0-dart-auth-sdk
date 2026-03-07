import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Represents the request for fetching metadata from the Auth0 `/metadata40` endpoint.
class Auth0GetMetadata40Request {
  /// The access token used to authorize the request.
  ///
  /// This must be a valid Bearer token. It is included in the Authorization
  /// header when making the request.
  final String accessToken;

  /// Constructs a [Auth0GetMetadata40Request].
  ///
  /// Throws an [ArgumentError] if [accessToken] is empty.
  Auth0GetMetadata40Request({required this.accessToken}) {
    if (accessToken.trim().isEmpty) {
      throw ArgumentError('accessToken must not be empty');
    }
  }
}

/// Represents the response from the Auth0 `/metadata40` endpoint.
class Auth0GetMetadata40Response {
  /// The metadata returned from the Auth0 API.
  ///
  /// This is typically a map of user-related or client-specific metadata fields.
  final Map<String, dynamic> metadata;

  /// Constructs a [Auth0GetMetadata40Response] from raw metadata.
  Auth0GetMetadata40Response({required this.metadata});

  /// Factory constructor to parse a JSON response into a [Auth0GetMetadata40Response].
  factory Auth0GetMetadata40Response.fromJson(Map<String, dynamic> json) {
    return Auth0GetMetadata40Response(metadata: json);
  }
}

/// Fetches metadata from the Auth0 `/metadata40` endpoint using the provided [accessToken].
///
/// - [auth0DomainUri]: The base Auth0 domain as a [Uri], e.g., `https://your-tenant.auth0.com`.
/// - [request]: An instance of [Auth0GetMetadata40Request] containing the access token.
/// - [client]: An optional [http.Client] for dependency injection and testing.
///
/// Returns an instance of [Auth0GetMetadata40Response] if successful.
///
/// Throws an [Exception] if the request fails due to network error, unauthorized access,
/// or unexpected response structure.
Future<Auth0GetMetadata40Response> auth0GetMetadata40({
  required Uri auth0DomainUri,
  required Auth0GetMetadata40Request request,
  http.Client? client,
}) async {
  final client0 = client ?? http.Client();
  final endpoint = auth0DomainUri.resolve('/metadata40');

  try {
    final response = await client0.get(
      endpoint,
      headers: {
        'Authorization': 'Bearer ${request.accessToken}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      return Auth0GetMetadata40Response.fromJson(jsonBody);
    } else {
      throw Exception(
        'Auth0 metadata fetch failed [${response.statusCode}]: ${response.body}',
      );
    }
  } catch (e) {
    throw Exception('Failed to get metadata from Auth0: $e');
  } finally {
    if (client == null) client0.close();
  }
}
