import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

import 'dart:html' as html;

class SamlTestScreen extends StatefulWidget {
  const SamlTestScreen({super.key});

  @override
  State<SamlTestScreen> createState() => _SamlTestScreenState();
}

class _SamlTestScreenState extends State<SamlTestScreen> {
  final domainController = TextEditingController(
    text: 'dev-2f3j64krke63frku.us.auth0.com',
  );
  final clientIdController = TextEditingController(
    text: 'EuWW7caLEYiFbA52lAhrgOVKLCbAIKBD',
  );
  final connectionController = TextEditingController(
    text: 'saml-enterprise-connection',
  );
  final redirectUriController = TextEditingController(
    text: 'http://localhost:3000/callback',
  ); // or your deployed URI

  String? generatedUrl;

  void _buildAndRedirect() {
    final samlService = Auth0EnterpriseSaml(
      domain: domainController.text.trim(),
      clientId: clientIdController.text.trim(),
    );

    final request = Auth0EnterpriseSamlRequest(
      connection: connectionController.text.trim(),
      redirectUri: redirectUriController.text.trim(),
    );

    final uri = samlService.buildAuthorizeUrl(request);
    setState(() {
      generatedUrl = uri.toString();
    });

    // Open in new tab
    html.window.open(uri.toString(), '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SAML Test Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Domain', domainController),
            _buildTextField('Client ID', clientIdController),
            _buildTextField('Connection', connectionController),
            _buildTextField('Redirect URI', redirectUriController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _buildAndRedirect,
              child: const Text('Build SAML Auth URL & Redirect'),
            ),
            const SizedBox(height: 20),
            if (generatedUrl != null) ...[
              const Text('Generated URL:'),
              SelectableText(generatedUrl!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
