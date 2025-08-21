import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class AuthorizeApplicationPage extends StatefulWidget {
  const AuthorizeApplicationPage({super.key});

  @override
  State<AuthorizeApplicationPage> createState() =>
      _AuthorizeApplicationPageState();
}

class _AuthorizeApplicationPageState extends State<AuthorizeApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();
  final _redirectUriController = TextEditingController();
  final _scopeController = TextEditingController(text: 'openid profile email');
  final _stateController = TextEditingController(text: 'xyz');
  final _audienceController = TextEditingController();
  final _connectionController = TextEditingController();
  final _promptController = TextEditingController();
  String _responseType = 'code';

  Uri? _authUrl;

  void _generateAuthUrl() {
    if (!_formKey.currentState!.validate()) return;

    final request = Auth0AuthorizeApplicationRequest(
      clientId: _clientIdController.text.trim(),
      redirectUri: Uri.parse(_redirectUriController.text.trim()),
      responseType: _responseType,
      scope: _scopeController.text.trim(),
      state: _stateController.text.trim(),
      audience: _audienceController.text.trim().isNotEmpty
          ? _audienceController.text.trim()
          : null,
      connection: _connectionController.text.trim().isNotEmpty
          ? _connectionController.text.trim()
          : null,
      prompt: _promptController.text.trim().isNotEmpty
          ? _promptController.text.trim()
          : null,
    );

    try {
      final service = Auth0AuthorizeApplicationService();
      final response = service.buildAuthorizationUrl(
        auth0DomainUri: Uri.parse('https://$AUTH0_DOMAIN'),
        request: request,
      );
      setState(() => _authUrl = response.url);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _redirectUriController.dispose();
    _scopeController.dispose();
    _stateController.dispose();
    _audienceController.dispose();
    _connectionController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authorize Application')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID *'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _redirectUriController,
                decoration: const InputDecoration(labelText: 'Redirect URI *'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _responseType,
                items: ['code', 'token', 'code token'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _responseType = value!),
                decoration: const InputDecoration(labelText: 'Response Type *'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _scopeController,
                decoration: const InputDecoration(
                  labelText: 'Scope (optional)',
                ),
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State (optional)',
                ),
              ),
              TextFormField(
                controller: _audienceController,
                decoration: const InputDecoration(
                  labelText: 'Audience (optional)',
                ),
              ),
              TextFormField(
                controller: _connectionController,
                decoration: const InputDecoration(
                  labelText: 'Connection (optional)',
                ),
              ),
              TextFormField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'Prompt (optional)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateAuthUrl,
                child: const Text('Generate Authorization URL'),
              ),
              const SizedBox(height: 20),
              if (_authUrl != null) ...[
                const Text(
                  'Authorization URL:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SelectableText(_authUrl.toString()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
