import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class Auth0LoginPage extends StatefulWidget {
  const Auth0LoginPage({super.key});

  @override
  State<Auth0LoginPage> createState() => _Auth0LoginPageState();
}

class _Auth0LoginPageState extends State<Auth0LoginPage> {
  final _usernameController = TextEditingController(text: 'vbhasker@aortem.io');
  final _passwordController = TextEditingController(text: 'Crazy@life1');
  final _connectionController = TextEditingController(
    text: "Username-Password-Authentication",
  );
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _clientSecretController = TextEditingController(text: CLIENT_SECRET);
  final _scopeController = TextEditingController(text: "openid profile email");
  final _audienceController = TextEditingController(text: API_IDENTIFIER);
  final _domainController = TextEditingController(text: AUTH0_DOMAIN);

  bool _usePasswordRealm = true; // default to password-realm
  String _status = "";
  Auth0AuthenticateUserResponse? _response;

  Future<void> _authenticate() async {
    setState(() {
      _status = "Authenticating...";
      _response = null;
    });

    try {
      final service = Auth0AuthenticateUser(domain: _domainController.text);

      final request = Auth0AuthenticateUserRequest(
        username: _usernameController.text,
        password: _passwordController.text,
        connection: _connectionController.text,
        clientId: _clientIdController.text,
        clientSecret: _clientSecretController.text.isEmpty
            ? null
            : _clientSecretController.text,
        scope: _scopeController.text.isEmpty ? null : _scopeController.text,
        audience: _audienceController.text.isEmpty
            ? null
            : _audienceController.text,
        usePasswordRealm: _usePasswordRealm,
      );

      final result = await service.authenticate(request: request);

      setState(() {
        _status = "Authentication successful!";
        _response = result;
      });
    } catch (e) {
      setState(() {
        _status = "Error: $e";
      });
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth0 Authenticate User Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text("Use Password-Realm Grant"),
              value: _usePasswordRealm,
              onChanged: (val) {
                setState(() => _usePasswordRealm = val);
              },
            ),
            _buildTextField(
              "Auth0 Domain (e.g., your-tenant.auth0.com)",
              _domainController,
            ),
            const SizedBox(height: 12),
            _buildTextField("Username / Email", _usernameController),
            const SizedBox(height: 12),
            _buildTextField("Password", _passwordController, obscure: true),
            const SizedBox(height: 12),
            _buildTextField(
              _usePasswordRealm ? "Realm" : "Connection",
              _connectionController,
            ),
            const SizedBox(height: 12),
            _buildTextField("Client ID", _clientIdController),
            const SizedBox(height: 12),
            _buildTextField(
              "Client Secret (optional)",
              _clientSecretController,
            ),
            const SizedBox(height: 12),
            _buildTextField("Scope (optional)", _scopeController),
            const SizedBox(height: 12),
            _buildTextField("Audience (optional)", _audienceController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text("Authenticate"),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: TextStyle(
                color: _status.startsWith("Error") ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_response != null) ...[
              const SizedBox(height: 20),
              const Text(
                "Response:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SelectableText("Access Token: ${_response!.accessToken}"),
              SelectableText("ID Token: ${_response!.idToken}"),
              if (_response!.refreshToken != null)
                SelectableText("Refresh Token: ${_response!.refreshToken}"),
              SelectableText("Token Type: ${_response!.tokenType}"),
              if (_response!.expiresIn != null)
                SelectableText("Expires In: ${_response!.expiresIn} seconds"),
            ],
          ],
        ),
      ),
    );
  }
}
