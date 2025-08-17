import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:uuid/uuid.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class Auth0PassiveLoginScreen extends StatefulWidget {
  const Auth0PassiveLoginScreen({super.key});

  @override
  State<Auth0PassiveLoginScreen> createState() =>
      _Auth0PassiveLoginScreenState();
}

class _Auth0PassiveLoginScreenState extends State<Auth0PassiveLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'vbhasker@aortem.io');
  final _passwordController = TextEditingController(text: 'Hello@123');
  final _connectionController = TextEditingController(
    text: 'Username-Password-Authentication',
  );
  final _clientIdController = TextEditingController(text: CLIENT_ID);
  final _scopeController = TextEditingController(text: 'openid profile email');
  final _audienceController = TextEditingController(text: API_IDENTIFIER);

  String _statusMessage = '';
  bool _loading = false;

  Future<void> _handlePassiveLogin() async {
    setState(() {
      _statusMessage = '';
      _loading = true;
    });

    final sdk = Auth0DatabaseAdLdapPassive(
      domain: AUTH0_DOMAIN,
      clientId: _clientIdController.text.trim(),
    );

    void redirectToPassiveLogin({
      required String domain,
      required String clientId,
      required String redirectUri,
      String? connection,
      String? audience,
      String scope = 'openid profile email',
    }) {
      final nonce = const Uuid().v4();
      final state = const Uuid().v4();

      final authUrl = Uri.https(domain, '/authorize', {
        'response_type': 'token id_token',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scope,
        if (audience != null) 'audience': audience,
        if (connection != null) 'connection': connection,
        'nonce': nonce,
        'state': state,
      });

      html.window.location.href = authUrl.toString(); // ✅ Redirects the browser
    }

    try {
      // final response = await sdk.authenticate(
      //   username: _usernameController.text.trim(),
      //   password: _passwordController.text.trim(),
      //   connection: _connectionController.text.trim(),
      //   scope: _scopeController.text.trim(),
      //   audience: _audienceController.text.trim(),
      // );
      redirectToPassiveLogin(
        domain: AUTH0_DOMAIN,
        clientId: _clientIdController.text.trim(),
        redirectUri:
            'http://localhost:3000/callback', // Must be whitelisted in Auth0
        audience: _audienceController.text.trim(),
        connection: _connectionController.text.trim(),
        scope: _scopeController.text.trim(),
      );

      setState(() {
        _statusMessage = '✅ Login Successful\n\n';
        // 'Access Token: ${response.accessToken}\n\n'
        // 'ID Token: ${response.idToken}\n\n'
        // 'Token Type: ${response.tokenType}\n'
        // 'Expires In: ${response.expiresIn ?? 'N/A'}';
      });
    } on Auth0DatabaseAdLdapPassiveException catch (e) {
      setState(() {
        _statusMessage = '❌ Error: ${e.message}\nDetails: ${e.errorDetails}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Unexpected Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
      sdk.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_statusMessage);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth0 Passive Login (Database/AD/LDAP)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                controller: _connectionController,
                decoration: const InputDecoration(labelText: 'Connection'),
              ),
              TextFormField(
                controller: _clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID'),
              ),
              TextFormField(
                controller: _scopeController,
                decoration: const InputDecoration(labelText: 'Scope'),
              ),
              TextFormField(
                controller: _audienceController,
                decoration: const InputDecoration(labelText: 'Audience'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _handlePassiveLogin,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
