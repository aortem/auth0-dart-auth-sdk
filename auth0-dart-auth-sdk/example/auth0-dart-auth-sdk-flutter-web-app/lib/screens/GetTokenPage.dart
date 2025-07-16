import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_get_token_request.dart';

class GetTokenPage extends StatefulWidget {
  const GetTokenPage({super.key});

  @override
  State<GetTokenPage> createState() => _GetTokenPageState();
}

class _GetTokenPageState extends State<GetTokenPage> {
  String _result = '';

  Future<void> _getToken() async {
    try {
      final request = AortemAuth0GetTokenRequest(
        grantType: 'authorization_code',
        clientId: CLIENT_ID,
        clientSecret: 'YOUR_CLIENT_SECRET', // Only if needed
        code: 'AUTHORIZATION_CODE_FROM_CALLBACK',
        redirectUri: REDIRECT_URI,
        scope: 'openid profile email',
        audience: 'https://yourapi.com',
      );

      final response = await aortemAuth0GetToken(
        domain: AUTH0_DOMAIN,
        request: request,
        client: http.Client(),
      );

      setState(() {
        _result = '''
Access Token: ${response.accessToken}
ID Token: ${response.idToken}
Refresh Token: ${response.refreshToken}
Token Type: ${response.tokenType}
Expires In: ${response.expiresIn}
        ''';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth0 Get Token')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getToken,
              child: const Text('Get Token'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
