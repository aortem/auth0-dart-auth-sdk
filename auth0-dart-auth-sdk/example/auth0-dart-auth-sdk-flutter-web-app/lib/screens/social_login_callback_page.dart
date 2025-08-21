import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class CallbackPage extends StatefulWidget {
  const CallbackPage({super.key});

  @override
  State<CallbackPage> createState() => _CallbackPageState();
}

class _CallbackPageState extends State<CallbackPage> {
  String? _message = 'Processing login...';

  @override
  void initState() {
    super.initState();
    _handleAuthCallback();
  }

  Future<void> _handleAuthCallback() async {
    final uri = Uri.base;
    final code = uri.queryParameters['code'];

    if (code == null) {
      setState(() => _message = 'Error: no code found in URL');
      return;
    }

    setState(() {
      _message = 'Loading...';
    });
    final authService = Auth0SocialLogin(
      domain: AUTH0_DOMAIN,
      clientId: CLIENT_ID,
    );
    try {
      final response = await authService.authenticate(
        socialAccessToken: code,
        connection: 'google-oauth2',
      );
      _message = '$response';
    } catch (e) {
      _message = '$e';
    }
    setState(() {});

    /* final tokenUrl = Uri.https(AUTH0_DOMAIN, '/oauth/token');

    final response = await http.post(
      tokenUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'grant_type': 'authorization_code',
        'client_id': CLIENT_ID,
        'code': code,
        'redirect_uri': REDIRECT_URI,
        'code_verifier': codeVerifier,
      }),
    );

    if (response.statusCode == 200) {
      final tokens = jsonDecode(response.body);
      print('Login successful!\nAccess token:\n${tokens['access_token']}');
      setState(
        () => _message =
            'Login successful!\nAccess token:\n${tokens['access_token']}',
      );
    } else {
      print('Error exchanging code: ${response.body}');
      setState(() => _message = 'Error exchanging code: ${response.body}');
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auth0 Callback')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(_message ?? ''),
        ),
      ),
    );
  }
}
