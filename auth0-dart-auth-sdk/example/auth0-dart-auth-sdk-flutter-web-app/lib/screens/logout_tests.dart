import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class Auth0LogoutTestScreen extends StatefulWidget {
  const Auth0LogoutTestScreen({super.key});

  @override
  State<Auth0LogoutTestScreen> createState() => _Auth0LogoutTestScreenState();
}

class _Auth0LogoutTestScreenState extends State<Auth0LogoutTestScreen> {
  final _auth0DomainController = TextEditingController(text: AUTH0_DOMAIN);
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _returnToController = TextEditingController(text: "");
  bool _federated = false;

  String? _generatedUrl;
  String? _errorMessage;

  void _generateLogoutUrl() {
    setState(() {
      _errorMessage = null;
      _generatedUrl = null;
    });

    try {
      final service = Auth0Logout(
        auth0Domain: _auth0DomainController.text.trim(),
      );

      final request = Auth0LogoutRequest(
        clientId: _clientIdController.text.trim(),
        returnTo: _returnToController.text.trim().isEmpty
            ? null
            : _returnToController.text.trim(),
        federated: _federated,
      );

      final response = service.generateLogoutUrl(request);

      setState(() {
        _generatedUrl = response.logoutUrl;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auth0 Logout Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _auth0DomainController,
              decoration: const InputDecoration(
                labelText: "Auth0 Domain",
                hintText: "e.g. your-tenant.auth0.com",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _clientIdController,
              decoration: const InputDecoration(
                labelText: "Client ID",
                hintText: "Required",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _returnToController,
              decoration: const InputDecoration(
                labelText: "Return To URL",
                hintText: "Optional redirect after logout",
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _federated,
                  onChanged: (value) {
                    setState(() {
                      _federated = value ?? false;
                    });
                  },
                ),
                const Text("Federated Logout"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateLogoutUrl,
              child: const Text("Generate Logout URL"),
            ),
            const SizedBox(height: 20),
            if (_generatedUrl != null)
              SelectableText(
                "Generated URL:\n$_generatedUrl",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_errorMessage != null)
              Text(
                "Error: $_errorMessage",
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
