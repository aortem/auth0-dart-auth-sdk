import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class OidcLogoutGeneratorPage extends StatefulWidget {
  const OidcLogoutGeneratorPage({super.key});

  @override
  _OidcLogoutGeneratorPageState createState() =>
      _OidcLogoutGeneratorPageState();
}

class _OidcLogoutGeneratorPageState extends State<OidcLogoutGeneratorPage> {
  final _auth0DomainController = TextEditingController(text: AUTH0_DOMAIN);
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _idTokenHintController = TextEditingController();
  final _postLogoutRedirectUriController = TextEditingController();
  final _stateController = TextEditingController();

  String? _generatedUrl;

  void _generateUrl() {
    final domain = _auth0DomainController.text.trim();
    final clientId = _clientIdController.text.trim();

    if (domain.isEmpty || clientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auth0 Domain and Client ID are required.")),
      );
      return;
    }

    try {
      final logoutService = Auth0OidcLogout(auth0Domain: domain);

      final request = Auth0OidcLogoutRequest(
        clientId: clientId,
        idTokenHint: _idTokenHintController.text.trim().isNotEmpty
            ? _idTokenHintController.text.trim()
            : null,
        postLogoutRedirectUri:
            _postLogoutRedirectUriController.text.trim().isNotEmpty
            ? _postLogoutRedirectUriController.text.trim()
            : null,
        state: _stateController.text.trim().isNotEmpty
            ? _stateController.text.trim()
            : null,
      );

      final response = logoutService.generateLogoutUrl(request);

      setState(() {
        _generatedUrl = response.logoutUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test SDK: OIDC Logout URL Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _auth0DomainController,
              decoration: InputDecoration(
                labelText: "Auth0 Domain (e.g., your-tenant.auth0.com)",
              ),
            ),
            TextField(
              controller: _clientIdController,
              decoration: InputDecoration(labelText: "Client ID"),
            ),
            TextField(
              controller: _idTokenHintController,
              decoration: InputDecoration(
                labelText: "ID Token Hint (optional)",
              ),
            ),
            TextField(
              controller: _postLogoutRedirectUriController,
              decoration: InputDecoration(
                labelText: "Post Logout Redirect URI (optional)",
              ),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: "State (optional)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateUrl,
              child: Text("Generate Logout URL"),
            ),
            if (_generatedUrl != null) ...[
              SizedBox(height: 20),
              SelectableText(
                "Generated Logout URL:\n$_generatedUrl",
                style: TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
