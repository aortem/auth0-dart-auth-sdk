import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class Auth0LoginScreen extends StatefulWidget {
  const Auth0LoginScreen({super.key});

  @override
  State<Auth0LoginScreen> createState() => _Auth0LoginScreenState();
}

class _Auth0LoginScreenState extends State<Auth0LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _resultMessage = '';
  bool _isLoading = false;

  final _authService = Auth0LoginService(
    auth0Domain: AUTH0_DOMAIN, // 🔁 Replace with actual domain
  );

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _resultMessage = '';
    });

    final request = Auth0LoginRequest(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      connection: 'Username-Password-Authentication',
      clientId: CLIENT_ID, // 🔁 Replace with actual client ID
      audience: API_IDENTIFIER, // optional
      scope: 'CustomScope',
    );

    try {
      final response = await _authService.login(request);
      setState(() {
        _resultMessage =
            '''
✅ Login Successful!
Access Token: ${response.accessToken}
ID Token: ${response.idToken}
Expires In: ${response.expiresIn}
''';
      });
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Login Failed:\n$e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _authService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth0 Login Test')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Credentials to Login via Auth0',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username or Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
                const SizedBox(height: 20),
                SelectableText(
                  _resultMessage,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
