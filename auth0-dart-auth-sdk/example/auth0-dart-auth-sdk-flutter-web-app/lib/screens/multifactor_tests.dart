import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';

class MultifactorTestScreen extends StatefulWidget {
  const MultifactorTestScreen({super.key});

  @override
  State<MultifactorTestScreen> createState() => _MultifactorTestScreenState();
}

class _MultifactorTestScreenState extends State<MultifactorTestScreen> {
  // Multifacotr Verify Test Function

  String multifactorVerifyResponse = '';
  String multifactorVerifyResponseError = '';

  void multifactorVerifyTest() async {
    setState(() {
      multifactorVerifyResponse = 'Loading...';
    });
    final client = AortemAuth0MultiFactorService(
      auth0DomainUri: Uri.parse(AUTH0_DOMAIN),
    );

    // Construct the MFA verification request with the MFA token and the OTP provided by the user.
    final request = AortemAuth0MultiFactorVerifyRequest(
      mfaToken: MFA_TOKEN,
      otp: '123456', // The one-time password entered by the user.
    );

    try {
      final response = await client.verify(request);
      if (kDebugMode) {
        print('MFA Verified Successfully!');
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
      multifactorVerifyResponse =
          'MFA Verified Successfully! \n Access Token: ${response.accessToken} \n ID Token: ${response.idToken} \n Refresh Token: ${response.refreshToken} \n Token Type: ${response.tokenType} \n Expires In: ${response.expiresIn} seconds';
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying MFA: $e');
      }
      multifactorVerifyResponseError = '$e';
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
              // Multifactor Verify widgets
              TextButton(
                onPressed: () {
                  multifactorVerifyTest();
                },
                child: const Text('Multifactor Verify Test'),
              ),
              Text(multifactorVerifyResponse),
              Text(multifactorVerifyResponseError),
            ],
          ),
        ),
      ),
    );
  }
}
