import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/material.dart';

class MultiFactorVerifyTestScreen extends StatefulWidget {
  const MultiFactorVerifyTestScreen({super.key});

  @override
  State<MultiFactorVerifyTestScreen> createState() =>
      _MultiFactorVerifyTestScreenState();
}

class _MultiFactorVerifyTestScreenState
    extends State<MultiFactorVerifyTestScreen> {
  final _mfaTokenController = TextEditingController();
  final _otpController = TextEditingController();

  String _result = '';
  bool _loading = false;

  Future<void> _verifyMfa() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    final service = Auth0MultiFactorService(
      auth0DomainUri: Uri.parse("https://dev-2f3j64krke63frku.us.auth0.com"),
    );

    final request = Auth0MultiFactorVerifyRequest(
      mfaToken: _mfaTokenController.text.trim(),
      otp: _otpController.text.trim(),
    );

    try {
      final Auth0MultiFactorVerifyResponse response = await service.verify(
        request,
      );

      setState(() {
        _result =
            '''
✅ MFA Verified Successfully!

Access Token: ${response.accessToken}
ID Token: ${response.idToken}
Token Type: ${response.tokenType}
Refresh Token: ${response.refreshToken ?? "N/A"}
Expires In: ${response.expiresIn ?? "N/A"} seconds
''';
      });
    } on Auth0MultifactorVerifyException catch (e) {
      setState(() {
        _result =
            '❌ MFA Verification Failed\nStatus: ${e.statusCode}\nMessage: ${e.message}\nDetails: ${e.details}';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Unexpected Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _mfaTokenController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MFA Verify Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _mfaTokenController,
              decoration: const InputDecoration(
                labelText: "MFA Token",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: "One-Time Password (OTP)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _verifyMfa,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Verify MFA"),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
