import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/AcceptRequestPage.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/AddAuthenticatorPage.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/GetTokenPage.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/IdpSSOScreen.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/OobVerifyScreen_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/authentication_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/authorization_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/authorize_application_page.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/authorize_endpoint_page.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/get_metadata_page.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/list_authenticators_page.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/multifactor_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/recovery_code_screen.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/social_login_callback_page.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/user_info_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/logout_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';

import 'screens/dynamicClientRegistrationPage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: Uri.base.path,
      routes: {
        '/': (context) =>
            MyHomePage(title: 'Auth0 Dart Auth SDK Demo Home Page'),
        '/callback': (context) => CallbackPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const AuthenticationTestScreen(),
                ),
              );
            },
            child: const Text('Authentication Methods'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LogoutTestScreen(),
                ),
              );
            },
            child: const Text('Logout Methods'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const AuthorizationTestScreen(),
                ),
              );
            },
            child: const Text('Authorization Methods'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const UserInfoTestScreen(),
                ),
              );
            },
            child: const Text('User Info Methods'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const MultifactorTestScreen(),
                ),
              );
            },
            child: const Text('Multifactor '),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => OobVerifyScreen(),
                ),
              );
            },
            child: const Text('OOB Verify '),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => RecoveryCodeScreen(),
                ),
              );
            },
            child: const Text('Recovery Code '),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AddAuthenticatorPage(),
                ),
              );
            },
            child: const Text('Add Authenticator'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ListAuthenticatorsPage(
                    accessToken: ACCESS_TOKEN, // Pass the access token here
                  ),
                ),
              );
            },
            child: const Text('List Authenticators'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AcceptRequestPage(
                    ticket:
                        'abc123456', // The ticket is a query parameter in the magic link Auth0 sends to the user when using passwordless login (via email or SMS).
                    clientId: CLIENT_ID, // Pass the client ID here
                    auth0Domain: AUTH0_DOMAIN, // Pass the Auth0 domain here
                  ),
                ),
              );
            },
            child: const Text('Accept Request'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => GetMetadataPage(
                    accessToken: ACCESS_TOKEN, // Pass the access token here
                    auth0DomainUri: Uri.parse(
                      'https://dev-ukd22ypmza3du5by.us.auth0.com',
                    ),
                  ),
                ),
              );
            },
            child: const Text('Get Metadata'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      DynamicClientRegistrationPage(),
                ),
              );
            },
            child: const Text('Dynamic Client Registration'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AuthorizeApplicationPage(),
                ),
              );
            },
            child: const Text('Authorize Application'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AuthorizeEndpointPage(),
                ),
              );
            },
            child: const Text('Authorize Endpoint'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => GetTokenPage(),
                ),
              );
            },
            child: const Text('Get Token'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => IdpSSOScreen(),
                ),
              );
            },
            child: const Text('IdP SSO'),
          ),
        ],
      ),
    );
  }
}
