import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';

class AuthorizationTestScreen extends StatefulWidget {
  const AuthorizationTestScreen({super.key});

  @override
  State<AuthorizationTestScreen> createState() =>
      _AuthorizationTestScreenState();
}

class _AuthorizationTestScreenState extends State<AuthorizationTestScreen> {
  // Sign Up Method

  String signupResponse = '';
  String signupResponseError = '';

  void signupTest() async {
    setState(() {
      signupResponse = 'Loading...';
    });
    final client = AortemAuth0Signup();

    // Construct the request with user credentials and connection info.
    final request = AortemAuth0SignupRequest(
      clientId: CLIENT_ID,
      email: 'user@example2.com',
      password: 'user_password47#',
      connection: 'Username-Password-Authentication',
      // Optionally, provide a username or additional user metadata.
      username: 'newuser',
      userMetadata: {'plan': 'premium'},
    );

    try {
      final response = await client.aortemAuth0Signup(request, AUTH0_DOMAIN);
      if (kDebugMode) {
        print('User signed up successfully!');
        print('Email: ${response.email}');
        if (response.userId != null) {
          print('User ID: ${response.userId}');
        }
      }
      signupResponse =
          'User signed up successfully! \n Email: ${response.email} \n User ID: ${response.userId}';
    } catch (e) {
      if (kDebugMode) {
        print('Error signing up user: $e');
      }
      signupResponseError = '$e';
    }

    setState(() {});
  }

  //Get Code or Link Test Function

  String getCodeOrLinkResponse = '';
  String getCodeOrLinkResponseError = '';

  void getCodeOrLinkTest() async {
    setState(() {
      getCodeOrLinkResponse = 'Loading...';
    });
    final authService = AortemAuth0GetCodeOrLink(domain: AUTH0_DOMAIN);

    // Construct the request for an email-based passwordless flow.
    final request = AortemAuth0GetCodeOrLinkRequest(
      clientId: CLIENT_ID,
      connection: 'email',
      email: 'user@example.com',
      send: 'code', // or 'link' to send a magic link
    );

    try {
      final response = await authService.sendCodeOrLink(request: request);
      if (response.success) {
        if (kDebugMode) {
          print('Code or link sent successfully.');
        }
        getCodeOrLinkResponse = 'Code or link sent successfully: $response';
      }
    } catch (e) {
      getCodeOrLinkResponseError = '$e';
    }
    setState(() {});
  }

  //Authenticate User Test Function

  String authenticateUserResponse = '';
  String authenticateUserResponseError = '';

  void authenticateUserTest() async {
    setState(() {
      authenticateUserResponse = 'Loading...';
    });
    final authService = AortemAuth0AuthenticateUser(domain: AUTH0_DOMAIN);

    // Construct the request with user credentials and connection details.
    final request = AortemAuth0AuthenticateUserRequest(
      username: 'user@example.com',
      password: 'user_password47#',
      connection: 'Username-Password-Authentication',
      clientId: CLIENT_ID,
      // Optionally, provide clientSecret, scope, or audience if needed.
    );

    try {
      final response = await authService.authenticate(request: request);
      if (kDebugMode) {
        print('User authenticated successfully!');
        print('Access Token: ${response.accessToken}');
        print('ID Token: ${response.idToken}');
        if (response.refreshToken != null) {
          print('Refresh Token: ${response.refreshToken}');
        }
        print('Token Type: ${response.tokenType}');
        if (response.expiresIn != null) {
          print('Expires In: ${response.expiresIn} seconds');
        }
      }
      authenticateUserResponse =
          'User authenticated successfully! \n Access Token: ${response.accessToken} \n ID Token: ${response.idToken} \n Refresh Token: ${response.refreshToken} \n Token Type: ${response.tokenType} \n Expires In: ${response.expiresIn} seconds';
    } catch (e) {
      if (kDebugMode) {
        print('Error authenticating user: $e');
      }
      authenticateUserResponseError = '$e';
    }

    setState(() {});
  }

  //Change Password Test Function

  String changePasswordResponse = '';
  String changePasswordResponseError = '';

  void changePasswordTest() async {
    setState(() {
      changePasswordResponse = 'Loading...';
    });
    final authService = AortemAuth0ChangePassword();

    // Construct the change password request with required parameters.
    final request = AortemAuth0ChangePasswordRequest(
      clientId: CLIENT_ID,
      email: 'user@example.com',
      connection: 'Username-Password-Authentication',
    );

    try {
      final response = await authService.aortemAuth0ChangePassword(
        request,
        AUTH0_DOMAIN,
      );
      changePasswordResponse =
          'Change Password Email Sent: ${response.message}';
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      changePasswordResponseError = '$e';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Authorization Methods')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Signup widgets
              TextButton(
                onPressed: () {
                  signupTest();
                },
                child: const Text('Signup Request Test'),
              ),
              Text(signupResponse),
              Text(signupResponseError),

              // Get Code Or Link widgets
              TextButton(
                onPressed: () {
                  getCodeOrLinkTest();
                },
                child: const Text('Get Code Or Link Test'),
              ),
              Text(getCodeOrLinkResponse),
              Text(getCodeOrLinkResponseError),

              // Authenticate User widgets
              TextButton(
                onPressed: () {
                  authenticateUserTest();
                },
                child: const Text('Authenticate User Test'),
              ),
              Text(authenticateUserResponse),
              Text(authenticateUserResponseError),

              // Change Password widgets
              TextButton(
                onPressed: () {
                  changePasswordTest();
                },
                child: const Text('Change Password Test'),
              ),
              Text(changePasswordResponse),
              Text(changePasswordResponseError),
            ],
          ),
        ),
      ),
    );
  }
}
