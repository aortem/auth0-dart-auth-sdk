import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class AuthenticationTestScreen extends StatefulWidget {
  const AuthenticationTestScreen({super.key});

  @override
  State<AuthenticationTestScreen> createState() =>
      _AuthenticationTestScreenState();
}

class _AuthenticationTestScreenState extends State<AuthenticationTestScreen> {
  //Login Test Function

  String loginResponse = '';
  String loginResponseError = '';

  void loginTest() async {
    setState(() {
      loginResponse = 'Loading...';
    });
    final client = Auth0LoginService(auth0Domain: AUTH0_DOMAIN);

    // Construct the request with user credentials and connection info.
    final request = Auth0LoginRequest(
      username: 'developer@aortem.io',
      password: 'Hello@123',
      connection: 'Username-Password-Authentication',
      clientId: CLIENT_ID,
      //scope: 'openid profile email', // Optional
      //audience: 'YOUR_AUDIENCE', // Optional
    );

    try {
      final response = await client.login(request);
      loginResponse = 'Login Successful! \n';
      loginResponse += 'Access Token: ${response.accessToken} \n';
      if (kDebugMode) {
        print('ID Token: ${response.idToken}');
        if (response.refreshToken != null) {
          print('Refresh Token: ${response.refreshToken}');
        }
        print('Token Type: ${response.tokenType}');
        if (response.expiresIn != null) {
          print('Expires In: ${response.expiresIn} seconds');
        }
      }
    } catch (e) {
      loginResponseError = 'Error during Auth0 login: $e';
      if (kDebugMode) {
        print('$e');
      }
    }
    setState(() {});
  }

  //Social Login Test Function

  String socialLoginResponse = '';
  String socialLoginResponseError = '';

  void socialLoginTest() async {
    setState(() {
      socialLoginResponse = 'Loading...';
    });
    final authService = Auth0SocialLogin(
      domain: AUTH0_DOMAIN,
      clientId: CLIENT_ID,
    );
    try {
      final response = await authService.authenticate(
        socialAccessToken: 'social-access-token',
        connection: 'social-connection',
      );
      socialLoginResponse = '$response';
    } catch (e) {
      socialLoginResponseError = '$e';
    }
    setState(() {});
  }

  //Backchannel Login Test Function

  String backChannelLoginResponse = '';
  String backChannelLoginResponseError = '';

  void backChannelLoginTest() async {
    setState(() {
      backChannelLoginResponse = 'Loading...';
    });
    final authService = Auth0BackChannelLogin(domain: AUTH0_DOMAIN);
    try {
      final response = await authService.initiate(
        clientId: CLIENT_ID,
        loginHint: 'user@example.com',
        scope: 'openid profile email', // Optional
        acrValues: 'urn:mace:incommon:iap:silver', // Optional
        bindingMessage: 'Confirm login on your device', // Optional
      );
      backChannelLoginResponse = '$response';
    } catch (e) {
      backChannelLoginResponseError = '$e';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Authentication Methods')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // login widgets
              TextButton(
                onPressed: () {
                  loginTest();
                },
                child: const Text('Login Request Test'),
              ),
              Text(loginResponse),
              Text(loginResponseError),

              // social login widgets
              TextButton(
                onPressed: () {
                  socialLoginTest();
                },
                child: const Text('Social Login Request Test'),
              ),
              Text(socialLoginResponse),
              Text(socialLoginResponseError),

              // backchannel login widgets
              TextButton(
                onPressed: () {
                  backChannelLoginTest();
                },
                child: const Text('Backchannel Login Request Test'),
              ),
              Text(backChannelLoginResponse),
              Text(backChannelLoginResponseError),
            ],
          ),
        ),
      ),
    );
  }
}
