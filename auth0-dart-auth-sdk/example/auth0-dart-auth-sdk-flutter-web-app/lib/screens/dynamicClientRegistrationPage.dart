import 'package:auth0_dart_auth_sdk_flutter_test_app/model/DynamicApplicationClientRegistration_model.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class DynamicClientRegistrationPage extends StatefulWidget {
  const DynamicClientRegistrationPage({super.key});

  @override
  State<DynamicClientRegistrationPage> createState() =>
      _DynamicClientRegistrationPageState();
}

class _DynamicClientRegistrationPageState
    extends State<DynamicClientRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _redirectUrisController = TextEditingController();
  final _logoUriController = TextEditingController();
  final _clientUriController = TextEditingController();

  String? _appType = 'regular_web';
  List<String> _selectedGrantTypes = [];

  bool _isLoading = false;
  AortemAuth0DynamicApplicationClientRegistrationResponse? _response;

  final _grantTypesOptions = [
    'authorization_code',
    'refresh_token',
    'implicit',
    'client_credentials',
    'password',
  ];
  final _appTypeOptions = ['native', 'spa', 'regular_web', 'non_interactive'];

  Future<void> _registerClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _response = null;
    });

    final apiClient = AortemAuth0MfaApiClient(
      auth0Domain: AUTH0_DOMAIN,
    ); // Replace with your domain

    try {
      final request = AortemAuth0DynamicApplicationClientRegistrationRequest(
        clientName: _clientNameController.text.trim(),
        redirectUris: _redirectUrisController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        appType: _appType,
        logoUri: _logoUriController.text.trim().isEmpty
            ? null
            : _logoUriController.text.trim(),
        clientUri: _clientUriController.text.trim().isEmpty
            ? null
            : _clientUriController.text.trim(),
        grantTypes: _selectedGrantTypes.isNotEmpty ? _selectedGrantTypes : null,
      );

      final result = await apiClient
          .aortemAuth0DynamicApplicationClientRegistration(request);

      setState(() {
        _response = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _redirectUrisController.dispose();
    _logoUriController.dispose();
    _clientUriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Client Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name *'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _redirectUrisController,
                decoration: const InputDecoration(
                  labelText: 'Redirect URIs (comma separated) *',
                  hintText:
                      'https://yourapp.com/callback, https://yourapp.com/auth',
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _appType,
                items: _appTypeOptions.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _appType = value),
                decoration: const InputDecoration(labelText: 'App Type'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _logoUriController,
                decoration: const InputDecoration(
                  labelText: 'Logo URI (optional)',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _clientUriController,
                decoration: const InputDecoration(
                  labelText: 'Client URI (optional)',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Grant Types (optional):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Column(
                children: _grantTypesOptions.map((type) {
                  return CheckboxListTile(
                    title: Text(type),
                    value: _selectedGrantTypes.contains(type),
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedGrantTypes.add(type);
                        } else {
                          _selectedGrantTypes.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerClient,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register Client'),
              ),
              const SizedBox(height: 20),
              if (_response != null) ...[
                const Divider(),
                const Text(
                  'Client Registered Successfully:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SelectableText('Client ID: ${_response!.clientId}'),
                SelectableText('Client Secret: ${_response!.clientSecret}'),
                SelectableText('Client Name: ${_response!.clientName}'),
                SelectableText(
                  'Redirect URIs: ${_response!.redirectUris.join(", ")}',
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final authUrl = AortemAuth0AuthorizeApplicationBuilder.build(
                      auth0DomainUri: Uri.parse(
                        'https://your-tenant.auth0.com',
                      ), // replace with your actual domain
                      request:
                          AortemAuth0AuthorizeApplicationClientRegisterRequest(
                            clientId: _response!.clientId,
                            redirectUri: Uri.parse(
                              _response!.redirectUris.first,
                            ),
                            responseType: 'code',
                            scope: 'openid profile email',
                            state: '123abc',
                          ),
                    ).url;

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Generated Auth URL'),
                        content: SelectableText(authUrl.toString()),
                        actions: [
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Generate Auth URL'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
