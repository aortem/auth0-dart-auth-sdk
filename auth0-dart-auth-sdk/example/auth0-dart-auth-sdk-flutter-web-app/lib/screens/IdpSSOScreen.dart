import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class IdpSSOScreen extends StatefulWidget {
  const IdpSSOScreen({super.key});

  @override
  State<IdpSSOScreen> createState() => _IdpSSOScreenState();
}

class _IdpSSOScreenState extends State<IdpSSOScreen> {
  String? generatedUrl;
  String? error;

  void _generateSSOUrl() {
    try {
      final request = AortemAuth0IdpInitiatedSSOFlowRequest(
        clientId: CLIENT_ID,
        redirectUri: REDIRECT_URI,
        connection: 'Username-Password-Authentication',
        protocol: 'oidc',
      );

      final response = aortemAuth0IdpInitiatedSSOFlow(
        auth0DomainUri: Uri.parse('https://$AUTH0_DOMAIN'),
        request: request,
      );

      setState(() {
        generatedUrl = response.ssoUrl.toString();
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        generatedUrl = null;
      });
    }
  }

  void _redirectToSSO() {
    if (generatedUrl != null) {
      // Flutter Web redirect
      // ignore: html_web_unnecessary_import

      html.window.location.href = generatedUrl!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IdP Initiated SSO Flow')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _generateSSOUrl,
              child: const Text('Generate SSO URL'),
            ),
            const SizedBox(height: 10),
            if (generatedUrl != null) ...[
              SelectableText('Generated SSO URL:\n$generatedUrl'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _redirectToSSO,
                child: const Text('Redirect to Auth0'),
              ),
            ],
            if (error != null)
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
