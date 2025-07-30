import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorizeEndpointPage extends StatelessWidget {
  const AuthorizeEndpointPage({super.key});

  void _startAuthorizationFlow(BuildContext context) async {
    try {
      final endpoint = AortemAuth0AuthorizeEndpoint(
        auth0DomainUri: Uri.parse('https://$AUTH0_DOMAIN'),
      );

      final request = AortemAuth0AuthorizeEndpointRequest(
        clientId: CLIENT_ID,
        redirectUri: Uri.parse(REDIRECT_URI),
        responseType: 'code',
        scope: 'openid profile email',
        state: 'someRandomState123',
        nonce: 'secureNonceValue456',
        prompt: 'login',
        maxAge: 3600,
        connection: 'Username-Password-Authentication',
      );

      final response = endpoint.generateAuthorizeUrl(request: request);

      final uri = response.url;
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth0 Authorize Endpoint')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _startAuthorizationFlow(context),
          child: const Text('Launch Auth0 Login'),
        ),
      ),
    );
  }
}
