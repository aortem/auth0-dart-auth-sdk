import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';

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
    final client = AortemAuth0LoginService(auth0Domain: AUTH0_DOMAIN);

    // Construct the request with user credentials and connection info.
    final request = AortemAuth0LoginRequest(
      username: 'user@example.com',
      password: 'user_password47#',
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
    // Alternative way to do the social login, ignoring the SDK and using a direct HTTP Request
    /*final codeChallenge =
        'dummy_code_challenge_that_can_be_replaced_with_a_secure_challenge';
    final authUrl = Uri.https(AUTH0_DOMAIN, '/authorize', {
      'response_type': 'code',
      'client_id': CLIENT_ID,
      'redirect_uri': REDIRECT_URI,
      'scope': 'openid profile email',
      'state': 'abc123',
      'code_challenge': codeChallenge,
      'code_challenge_method': 'plain',
      'connection': 'google-oauth2', // Forces Google login
    });

    // Redirect browser to Auth0 login
    // ignore: undefined_prefixed_name
    js.context.callMethod('open', [authUrl.toString(), '_self']);*/

    //this requires a access token obtained directly from the third party login site

    setState(() {
      socialLoginResponse = 'Loading...';
    });
    final authService = AortemAuth0SocialLogin(
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

  //Enterprise SAML Login Test Function

  String enterpriseSAMLLoginResponse = '';
  String enterpriseSAMLLoginResponseError = '';

  void enterpriseSAMLLoginTest() async {
    setState(() {
      enterpriseSAMLLoginResponse = 'Loading...';
    });
    final authService = AortemAuth0EnterpriseSaml(domain: AUTH0_DOMAIN);
    try {
      final response = await authService.authenticate(
        samlRequest: 'samlRequest',
        connection: 'connection',
      );
      enterpriseSAMLLoginResponse = '$response';
    } catch (e) {
      enterpriseSAMLLoginResponseError = '$e';
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
    final authService = AortemAuth0BackChannelLogin(domain: AUTH0_DOMAIN);
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

  //adLdapPassive Login Test Function

  String adLdapPassiveLoginResponse = '';
  String adLdapPassiveLoginResponseError = '';

  void adLdapPassiveLoginTest() async {
    setState(() {
      adLdapPassiveLoginResponse = 'Loading...';
    });
    final authService = AortemAuth0DatabaseAdLdapPassive(
      domain: AUTH0_DOMAIN,
      clientId: CLIENT_ID,
    );
    try {
      final response = await authService.authenticate(
        username: 'user@example.com',
        password: 'user_password47#',
        connection:
            'Username-Password-Authentication', // or "active-directory", "ldap", etc.
        scope: 'openid profile email', // Optional
        audience: 'YOUR_API_IDENTIFIER', // Optional
      );
      adLdapPassiveLoginResponse = '$response';
    } catch (e) {
      adLdapPassiveLoginResponseError = '$e';
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

              // enterprise login widgets
              TextButton(
                onPressed: () {
                  enterpriseSAMLLoginTest();
                },
                child: const Text('Enterprise/SAML Login Request Test'),
              ),
              Text(enterpriseSAMLLoginResponse),
              Text(enterpriseSAMLLoginResponseError),

              // backchannel login widgets
              TextButton(
                onPressed: () {
                  backChannelLoginTest();
                },
                child: const Text('Backchannel Login Request Test'),
              ),
              Text(backChannelLoginResponse),
              Text(backChannelLoginResponseError),

              // adLdapPassive login widgets
              TextButton(
                onPressed: () {
                  adLdapPassiveLoginTest();
                },
                child: const Text('AdLdapPassive Login Request Test'),
              ),
              Text(adLdapPassiveLoginResponse),
              Text(adLdapPassiveLoginResponseError),
            ],
          ),
        ),
      ),
    );
  }
}
