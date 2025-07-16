import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_verify_oob_request_model.dart';

class OobVerifyScreen extends StatefulWidget {
  const OobVerifyScreen({super.key});

  @override
  _OobVerifyScreenState createState() => _OobVerifyScreenState();
}

class _OobVerifyScreenState extends State<OobVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _identifierController = TextEditingController();
  String _realm = 'email';
  bool _loading = false;
  String? _result;

  Future<void> _verifyOobCode() async {
    setState(() => _loading = true);
    final client = AortemAuth0MfaVerifyOob(auth0Domain: AUTH0_DOMAIN);

    try {
      final request = AortemAuth0VerifyOOBRequest(
        clientId: AUTH0_DOMAIN,
        oobCode: _codeController.text.trim(),
        realm: _realm,
        username: _realm == 'email' ? _identifierController.text.trim() : null,
        phoneNumber: _realm == 'sms' ? _identifierController.text.trim() : null,
      );

      final response = await client.verifyOOB(request);
      setState(() {
        _result = '''
✅ Verified Successfully!

Access Token: ${response.accessToken}
ID Token: ${response.idToken}
Refresh Token: ${response.refreshToken ?? 'N/A'}
Expires In: ${response.expiresIn ?? 'N/A'}
''';
      });
    } catch (e) {
      setState(() => _result = '❌ Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OOB Code Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _realm,
                onChanged: (value) => setState(() => _realm = value!),
                items: ['email', 'sms']
                    .map((r) => DropdownMenuItem(
                        value: r, child: Text(r.toUpperCase())))
                    .toList(),
              ),
              TextFormField(
                controller: _identifierController,
                decoration: InputDecoration(
                    labelText: _realm == 'email' ? 'Email' : 'Phone Number'),
              ),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'OOB Code'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyOobCode,
                child: Text(_loading ? 'Verifying...' : 'Verify'),
              ),
              const SizedBox(height: 20),
              if (_result != null)
                Text(_result!, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
