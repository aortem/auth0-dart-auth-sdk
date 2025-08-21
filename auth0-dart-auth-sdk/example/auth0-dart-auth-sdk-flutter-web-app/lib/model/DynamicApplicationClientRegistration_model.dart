import 'dart:convert';

import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

/// REQUEST MODEL for Dynamic Application Client Registration
class Auth0DynamicApplicationClientRegistrationRequest {
  final String clientName;
  final List<String> redirectUris;
  final String? appType;
  final String? logoUri;
  final String? clientUri;
  final List<String>? grantTypes;

  Auth0DynamicApplicationClientRegistrationRequest({
    required this.clientName,
    required this.redirectUris,
    this.appType,
    this.logoUri,
    this.clientUri,
    this.grantTypes,
  });

  Map<String, dynamic> toJson() => {
    'client_name': clientName,
    'redirect_uris': redirectUris,
    if (appType != null) 'app_type': appType,
    if (logoUri != null) 'logo_uri': logoUri,
    if (clientUri != null) 'client_uri': clientUri,
    if (grantTypes != null) 'grant_types': grantTypes,
  };
}

/// RESPONSE MODEL for Dynamic Application Client Registration
class Auth0DynamicApplicationClientRegistrationResponse {
  final String clientId;
  final String clientSecret;
  final String clientName;
  final List<String> redirectUris;

  Auth0DynamicApplicationClientRegistrationResponse({
    required this.clientId,
    required this.clientSecret,
    required this.clientName,
    required this.redirectUris,
  });

  factory Auth0DynamicApplicationClientRegistrationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return Auth0DynamicApplicationClientRegistrationResponse(
      clientId: json['client_id'],
      clientSecret: json['client_secret'],
      clientName: json['client_name'],
      redirectUris: List<String>.from(json['redirect_uris']),
    );
  }
}

/// API CLIENT method to register application
extension DynamicClientRegistration on Auth0MfaApiClient {
  Future<Auth0DynamicApplicationClientRegistrationResponse>
  Auth0DynamicApplicationClientRegistration(
    Auth0DynamicApplicationClientRegistrationRequest request,
  ) async {
    final url = Uri.parse('$auth0Domain/api/v2/clients');

    final response = await httpClient.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Make sure to add proper Authorization header if needed
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Client registration failed: ${response.statusCode} ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Auth0DynamicApplicationClientRegistrationResponse.fromJson(json);
  }
}
