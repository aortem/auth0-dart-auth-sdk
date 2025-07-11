import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/material.dart';

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
    final client = AortemAuth0LoginService(
      auth0Domain: 'your-tenant.auth0.com',
    );

    // Construct the request with user credentials and connection info.
    final request = AortemAuth0LoginRequest(
      username: 'user@example.com',
      password: 'user_password',
      connection: 'Username-Password-Authentication',
      clientId: 'YOUR_CLIENT_ID', // Optional
      scope: 'openid profile email', // Optional
      audience: 'YOUR_API_IDENTIFIER', // Optional
    );

    try {
      final response = await client.login(request);
      loginResponse = 'Login Successful! \n';
      loginResponse += 'Access Token: ${response.accessToken} \n';
      print('ID Token: ${response.idToken}');
      if (response.refreshToken != null) {
        print('Refresh Token: ${response.refreshToken}');
      }
      print('Token Type: ${response.tokenType}');
      if (response.expiresIn != null) {
        print('Expires In: ${response.expiresIn} seconds');
      }
    } catch (e) {
      loginResponseError = 'Error during Auth0 login: $e';
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
    final authService = AortemAuth0SocialLogin(
      domain: 'your-auth0-domain',
      clientId: 'your-client-id',
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
    final authService = AortemAuth0EnterpriseSaml(domain: 'your-auth0-domain');
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
    final authService = AortemAuth0BackChannelLogin(
      domain: 'your-auth0-domain',
    );
    try {
      final response = await authService.initiate(
        clientId: 'YOUR_CLIENT_ID',
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
      domain: 'your-auth0-domain',
      clientId: 'your-client-id',
    );
    try {
      final response = await authService.authenticate(
        username: 'user@example.com',
        password: 'user_password',
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
