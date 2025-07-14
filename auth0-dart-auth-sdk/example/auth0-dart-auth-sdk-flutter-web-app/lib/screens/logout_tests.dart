import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';

class LogoutTestScreen extends StatefulWidget {
  const LogoutTestScreen({super.key});

  @override
  State<LogoutTestScreen> createState() => _LogoutTestScreenState();
}

class _LogoutTestScreenState extends State<LogoutTestScreen> {
  //Logout Test Function

  String logoutResponse = '';
  String logoutResponseError = '';

  void logoutTest() async {
    setState(() {
      logoutResponse = 'Loading...';
    });
    final client = AortemAuth0Logout(auth0Domain: AUTH0_DOMAIN);

    try {
      // Construct the logout request with required and optional parameters.
      final request = client.generateLogoutUrl(
        AortemAuth0LogoutRequest(
          clientId: CLIENT_ID,
          returnTo: 'https://yourapp.com/logout-success', // Optional
          federated:
              true, // Optional: Log out of federated identity providers as well.
        ),
      );

      // Use this URL to redirect the user for logging out.
      logoutResponse = request.logoutUrl;
    } catch (e) {
      logoutResponseError = "$e";
    }

    setState(() {});
  }

  //Oidc Logout Test Function

  String oidcLogoutResponse = '';
  String oidcLogoutResponseError = '';

  void oidcLogoutTest() async {
    setState(() {
      oidcLogoutResponse = 'Loading...';
    });
    final client = AortemAuth0OidcLogout(auth0Domain: AUTH0_DOMAIN);

    try {
      // Construct the logout request with required and optional parameters.
      final request = client.generateLogoutUrl(
        AortemAuth0OidcLogoutRequest(
          clientId: CLIENT_ID,
          idTokenHint: 'YOUR_ID_TOKEN', // Optional
          postLogoutRedirectUri:
              'https://yourapp.com/logout-success', // Optional
          state: 'some_state_value', // Optional
        ),
      );

      // Use this URL to redirect the user for logging out.
      oidcLogoutResponse = request.logoutUrl;
    } catch (e) {
      oidcLogoutResponseError = "$e";
    }

    setState(() {});
  }

  //Enterprise SAML Login Test Function

  String samlLogoutResponse = '';
  String samlLogoutResponseError = '';

  void samlLogoutTest() async {
    setState(() {
      samlLogoutResponse = 'Loading...';
    });

    final client = AortemAuth0SamlLogout(domain: AUTH0_DOMAIN);

    try {
      // Construct the logout request with required and optional parameters.
      final request = client.buildLogoutUrl(
        AortemAuth0SamlLogoutRequest(
          clientId: CLIENT_ID,
          returnTo: 'https://yourapp.com/logout-success', // Optional
          federated:
              true, // Optional: Log out of federated identity providers as well.
        ),
      );

      // Use this URL to redirect the user for logging out.
      samlLogoutResponse = request.logoutUrl;
    } catch (e) {
      samlLogoutResponseError = "$e";
    }

    setState(() {});
  }

  //Global Token Revocation Test Function

  String globalTokenRevocationResponse = '';
  String globalTokenRevocationResponseError = '';

  void globalTokenRevocationTest() async {
    setState(() {
      globalTokenRevocationResponse = 'Loading...';
    });
    final authService = AortemAuth0GlobalTokenRevocation(domain: AUTH0_DOMAIN);

    // construct the revokation request with the given parameters
    final request = AortemAuth0GlobalTokenRevocationRequest(
      token: 'YOUR_REFRESH_TOKEN',
      clientId: CLIENT_ID,
      tokenTypeHint: 'refresh_token', // Optional
    );

    try {
      final response = await authService.revokeToken(request: request);
      if (response.success) {
        globalTokenRevocationResponse = 'Token Revoked Successfully';
      }
    } catch (e) {
      globalTokenRevocationResponseError = "$e";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Logout Methods')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logout widgets
              TextButton(
                onPressed: () {
                  logoutTest();
                },
                child: const Text('Logout Request Test'),
              ),
              Text(logoutResponse),
              Text(logoutResponseError),

              // OidcLogout login widgets
              TextButton(
                onPressed: () {
                  oidcLogoutTest();
                },
                child: const Text('OidcLogout Request Test'),
              ),
              Text(oidcLogoutResponse),
              Text(oidcLogoutResponseError),

              // Saml Logout widgets
              TextButton(
                onPressed: () {
                  samlLogoutTest();
                },
                child: const Text('SAML Logout Request Test'),
              ),
              Text(samlLogoutResponse),
              Text(samlLogoutResponseError),

              // Global Token Revocation Request widgets
              TextButton(
                onPressed: () {
                  globalTokenRevocationTest();
                },
                child: const Text('Global Token Revocation Request Test'),
              ),
              Text(globalTokenRevocationResponse),
              Text(globalTokenRevocationResponseError),
            ],
          ),
        ),
      ),
    );
  }
}
