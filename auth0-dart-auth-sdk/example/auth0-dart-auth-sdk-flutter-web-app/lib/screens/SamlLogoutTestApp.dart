import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class SamlLogoutTestApp extends StatelessWidget {
  const SamlLogoutTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth0SamlLogout Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SamlLogoutTestScreen(),
    );
  }
}

class SamlLogoutTestScreen extends StatefulWidget {
  const SamlLogoutTestScreen({super.key});

  @override
  State<SamlLogoutTestScreen> createState() => _SamlLogoutTestScreenState();
}

class _SamlLogoutTestScreenState extends State<SamlLogoutTestScreen> {
  final _domainController = TextEditingController(text: AUTH0_DOMAIN);
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _returnToController = TextEditingController(
    text: 'https://yourapp.com/logout-success',
  );
  bool _federated = false;

  String? _generatedUrl;
  String? _error;

  void _generateLogoutUrl() {
    setState(() {
      _error = null;
      _generatedUrl = null;
    });

    try {
      final service = Auth0SamlLogout(domain: _domainController.text.trim());

      final request = Auth0SamlLogoutRequest(
        clientId: _clientIdController.text.trim(),
        returnTo: _returnToController.text.trim().isNotEmpty
            ? _returnToController.text.trim()
            : null,
        federated: _federated,
      );

      final response = service.buildLogoutUrl(request);

      setState(() {
        _generatedUrl = response.logoutUrl;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SAML Logout Test UI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                labelText: 'Auth0 Domain',
                hintText: 'your-tenant.auth0.com',
              ),
            ),
            TextField(
              controller: _clientIdController,
              decoration: const InputDecoration(labelText: 'Client ID'),
            ),
            TextField(
              controller: _returnToController,
              decoration: const InputDecoration(
                labelText: 'Return To URL (Optional)',
              ),
            ),
            SwitchListTile(
              title: const Text('Federated Logout'),
              value: _federated,
              onChanged: (val) {
                setState(() {
                  _federated = val;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateLogoutUrl,
              child: const Text('Generate Logout URL'),
            ),
            const SizedBox(height: 16),
            if (_generatedUrl != null) ...[
              const Text(
                'Generated Logout URL:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(
                _generatedUrl!,
                style: const TextStyle(color: Colors.green),
              ),
            ],
            if (_error != null) ...[
              const Text(
                'Error:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
