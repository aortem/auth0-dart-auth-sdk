// lib/screens/recovery_code_screen.dart
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_verify_recovery_code_request_model.dart';

class RecoveryCodeScreen extends StatefulWidget {
  const RecoveryCodeScreen({super.key});

  @override
  State<RecoveryCodeScreen> createState() => _RecoveryCodeScreenState();
}

class _RecoveryCodeScreenState extends State<RecoveryCodeScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  bool _loading = false;
  String? _result;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _result = null;
    });

    final request = AortemAuth0VerifyRecoveryCodeRequest(
      clientId: CLIENT_ID,
      recoveryCode: _codeController.text.trim(),
      username: _emailController.text.trim(),
    );

    final apiClient = AortemAuth0MfaApiClient(auth0Domain: AUTH0_DOMAIN);

    try {
      final response = await apiClient.verifyRecoveryCode(request);
      setState(() {
        _result =
            '''
✅ Recovery Success
Access Token: ${response.accessToken}
ID Token: ${response.idToken}
''';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Recovery Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Recovery Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Verify'),
            ),
            const SizedBox(height: 20),
            if (_result != null)
              Text(_result!, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
