import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class PasswordlessTestApp extends StatefulWidget {
  const PasswordlessTestApp({super.key});

  @override
  State<PasswordlessTestApp> createState() => _PasswordlessTestAppState();
}

class _PasswordlessTestAppState extends State<PasswordlessTestApp> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _emailController = TextEditingController(text: "vbhasker@.io");
  String _connection = 'email';
  String _sendType = 'code';
  bool _loading = false;
  String? _resultMessage;

  final _domainController = TextEditingController(text: AUTH0_DOMAIN);

  Future<void> _sendRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _resultMessage = null;
    });

    try {
      // Ensure domain is clean for Uri.https()
      String cleanDomain = _domainController.text.trim();
      cleanDomain = cleanDomain.replaceAll(RegExp(r'^https?://'), '');

      final authService = Auth0GetCodeOrLink(domain: cleanDomain);

      final request = Auth0GetCodeOrLinkRequest(
        clientId: _clientIdController.text,
        connection: _connection,
        email: _emailController.text,
        send: _sendType,
        authParams: {'redirect_uri': REDIRECT_URI},
      );

      final response = await authService.sendCodeOrLink(request: request);

      setState(() {
        _resultMessage = response.message;
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _emailController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth0 Passwordless Tester')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // if (kIsWeb)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.yellow[100],
                child: Text(
                  "⚠️ Running in browser — make sure this origin is added to Auth0's 'Allowed Web Origins':\n${Uri.base.origin}",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _domainController,
                decoration: const InputDecoration(labelText: 'Auth0 Domain'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Auth0 domain' : null,
              ),
              TextFormField(
                controller: _clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID'),
                validator: (value) => value!.isEmpty ? 'Enter Client ID' : null,
              ),
              DropdownButtonFormField<String>(
                value: _connection,
                decoration: const InputDecoration(labelText: 'Connection Type'),
                items: const [
                  DropdownMenuItem(value: 'email', child: Text('Email')),
                  DropdownMenuItem(value: 'sms', child: Text('SMS')),
                ],
                onChanged: (value) {
                  setState(() {
                    _connection = value!;
                  });
                },
              ),
              if (_connection == 'email')
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      _connection == 'email' && (value == null || value.isEmpty)
                      ? 'Enter email'
                      : null,
                ),
              DropdownButtonFormField<String>(
                value: _sendType,
                decoration: const InputDecoration(labelText: 'Send Type'),
                items: const [
                  DropdownMenuItem(value: 'code', child: Text('Code')),
                  DropdownMenuItem(value: 'link', child: Text('Link')),
                ],
                onChanged: (value) {
                  setState(() {
                    _sendType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _sendRequest,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Send Code/Link'),
              ),
              if (_resultMessage != null) ...[
                const SizedBox(height: 20),
                Text(
                  _resultMessage!,
                  style: TextStyle(
                    color: _resultMessage!.startsWith('Error')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
