import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class AddAuthenticatorPage extends StatefulWidget {
  const AddAuthenticatorPage({super.key});

  @override
  State<AddAuthenticatorPage> createState() => _AddAuthenticatorPageState();
}

class _AddAuthenticatorPageState extends State<AddAuthenticatorPage> {
  final TextEditingController _mfaTokenController = TextEditingController();
  String? _qrCodeUrl;
  String? _secret;
  String? _error;

  bool _isLoading = false;

  Future<void> _addAuthenticator() async {
    setState(() {
      _isLoading = true;
      _qrCodeUrl = null;
      _secret = null;
      _error = null;
    });

    final client = AortemAuth0MfaAddAuthenticator(
      auth0Domain: AUTH0_DOMAIN, // Replace with your tenant
      httpClient: http.Client(), // from ds_standard_features
    );

    final request = AortemAuth0AddAuthenticatorRequest(
      mfaToken: _mfaTokenController.text.trim(),
      authenticatorType: 'otp',
    );

    try {
      final response = await client.aortemAuth0AddAuthenticator(request);
      setState(() {
        _qrCodeUrl = response.qrCodeUrl;
        _secret = response.secret;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Authenticator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _mfaTokenController,
              decoration: const InputDecoration(
                labelText: 'MFA Token',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _addAuthenticator,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Authenticator'),
            ),
            const SizedBox(height: 20),
            if (_qrCodeUrl != null) ...[
              Text('Scan this QR Code:'),
              Image.network(_qrCodeUrl!),
              SelectableText('Secret: $_secret'),
            ],
            if (_error != null) ...[
              const SizedBox(height: 20),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
