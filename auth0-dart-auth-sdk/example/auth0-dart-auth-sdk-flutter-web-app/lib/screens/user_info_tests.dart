import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';

class UserInfoTestScreen extends StatefulWidget {
  const UserInfoTestScreen({super.key});

  @override
  State<UserInfoTestScreen> createState() => _UserInfoTestScreenState();
}

class _UserInfoTestScreenState extends State<UserInfoTestScreen> {
  // Fetch User Info Test Function

  String userProfileResponse = '';
  String userProfileResponseError = '';

  void userProfileTest() async {
    setState(() {
      userProfileResponse = 'Loading...';
    });
    final client = AortemAuth0UserProfile();

    // Construct the request with user credentials and connection info.
    final request = AortemAuth0UserProfileRequest(accessToken: ACCESS_TOKEN);

    try {
      final profile = await client.aortemAuth0UserProfile(
        request,
        AUTH0_DOMAIN,
      );
      if (kDebugMode) {
        print('User Profile Retrieved:');
        print('User ID: ${profile.sub}');
        print('Name: ${profile.name}');
        print('Email: ${profile.email}');
        print('Picture: ${profile.picture}');
      }
      userProfileResponse =
          ''' User Profile Retrieved:
              User ID: ${profile.sub}
              Name: ${profile.name}
              Email: ${profile.email}
              Picture: ${profile.picture}
          ''';
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
      userProfileResponseError = '{$e}';
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
              // user profile widgets
              TextButton(
                onPressed: () {
                  userProfileTest();
                },
                child: const Text('Fetch User Profile Test'),
              ),
              Text(userProfileResponse),
              Text(userProfileResponseError),
            ],
          ),
        ),
      ),
    );
  }
}
