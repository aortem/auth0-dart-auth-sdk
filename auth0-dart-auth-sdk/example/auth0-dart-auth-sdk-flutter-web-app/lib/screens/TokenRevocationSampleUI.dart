import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

void main() {
  runApp(const MaterialApp(home: TokenRevocationSampleUI()));
}

class TokenRevocationSampleUI extends StatefulWidget {
  const TokenRevocationSampleUI({super.key});

  @override
  State<TokenRevocationSampleUI> createState() =>
      _TokenRevocationSampleUIState();
}

class _TokenRevocationSampleUIState extends State<TokenRevocationSampleUI> {
  final _domainController = TextEditingController(text: AUTH0_DOMAIN);
  final _tokenController = TextEditingController(text: "");
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _tokenTypeHintController = TextEditingController();

  String _resultMessage = '';
  bool _isLoading = false;

  Future<void> _revokeToken() async {
    setState(() {
      _isLoading = true;
      _resultMessage = '';
    });

    try {
      final service = Auth0GlobalTokenRevocation(
        domain: _domainController.text.trim(),
      );

      final request = Auth0GlobalTokenRevocationRequest(
        token: _tokenController.text.trim(),
        clientId: _clientIdController.text.trim(),
        tokenTypeHint: _tokenTypeHintController.text.trim().isNotEmpty
            ? _tokenTypeHintController.text.trim()
            : null,
      );

      final response = await service.revokeToken(request: request);

      setState(() {
        _resultMessage = response.success
            ? '✅ Token revoked successfully.'
            : '⚠ Token revocation failed.';
      });
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Auth0 Global Token Revocation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                labelText: 'Auth0 Domain (e.g., your-tenant.auth0.com)',
              ),
            ),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Token (refresh or access token)',
              ),
            ),
            TextField(
              controller: _clientIdController,
              decoration: const InputDecoration(labelText: 'Client ID'),
            ),
            TextField(
              controller: _tokenTypeHintController,
              decoration: const InputDecoration(
                labelText: 'Token Type Hint (optional)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _revokeToken,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Revoke Token'),
            ),
            const SizedBox(height: 20),
            Text(_resultMessage, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
