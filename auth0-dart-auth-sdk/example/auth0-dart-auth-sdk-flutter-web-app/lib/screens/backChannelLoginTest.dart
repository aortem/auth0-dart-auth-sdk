import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class BackChannelLoginTestScreen extends StatefulWidget {
  const BackChannelLoginTestScreen({super.key});

  @override
  State<BackChannelLoginTestScreen> createState() =>
      _BackChannelLoginTestScreenState();
}

class _BackChannelLoginTestScreenState
    extends State<BackChannelLoginTestScreen> {
  final _domainController = TextEditingController(text: AUTH0_DOMAIN);
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _loginHintController = TextEditingController(
    text: "vbhasker@aortem.ai",
  );
  final _scopeController = TextEditingController(text: 'openid profile email');
  final _acrValuesController = TextEditingController();
  final _bindingMessageController = TextEditingController();

  String _result = '';
  bool _loading = false;

  Future<void> _initiateLogin() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    final domain = _domainController.text.trim();
    final clientId = _clientIdController.text.trim();
    final loginHint = _loginHintController.text.trim();

    if (domain.isEmpty || clientId.isEmpty || loginHint.isEmpty) {
      setState(() {
        _loading = false;
        _result = '❌ Domain, Client ID, and Login Hint are required.';
      });
      return;
    }

    final loginService = Auth0BackChannelLogin(domain: domain);

    try {
      final response = await loginService.initiate(
        clientId: clientId,
        loginHint: loginHint,
        scope: _scopeController.text.trim().isEmpty
            ? null
            : _scopeController.text.trim(),
        acrValues: _acrValuesController.text.trim().isEmpty
            ? null
            : _acrValuesController.text.trim(),
        bindingMessage: _bindingMessageController.text.trim().isEmpty
            ? null
            : _bindingMessageController.text.trim(),
      );

      setState(() {
        _result =
            '''
✅ Success!
Auth Request ID: ${response.authReqId}
Expires In: ${response.expiresIn} sec
${response.interval != null ? "Interval: ${response.interval} sec" : ""}
        ''';
      });
    } on Auth0BackChannelLoginException catch (e) {
      setState(() {
        _result = '❌ Login Failed:\n${e.message}\nDetails: ${e.errorDetails}';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Unexpected error: $e';
      });
    } finally {
      loginService.close();
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Back-Channel Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(labelText: 'Auth0 Domain'),
            ),
            TextField(
              controller: _clientIdController,
              decoration: const InputDecoration(labelText: 'Client ID'),
            ),
            TextField(
              controller: _loginHintController,
              decoration: const InputDecoration(
                labelText: 'Login Hint (email/user ID)',
              ),
            ),
            TextField(
              controller: _scopeController,
              decoration: const InputDecoration(labelText: 'Scope (optional)'),
            ),
            TextField(
              controller: _acrValuesController,
              decoration: const InputDecoration(
                labelText: 'ACR Values (optional)',
              ),
            ),
            TextField(
              controller: _bindingMessageController,
              decoration: const InputDecoration(
                labelText: 'Binding Message (optional)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _initiateLogin,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Initiate Back-Channel Login'),
            ),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
