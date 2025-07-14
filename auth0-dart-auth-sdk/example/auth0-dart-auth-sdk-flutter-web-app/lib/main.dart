import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/authentication_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/authorization_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/multifactor_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/social_login_callback_page.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/user_info_tests.dart';
import 'package:auth0_dart_auth_sdk_flutter_test_app/screens/logout_tests.dart';
import 'package:flutter/material.dart';

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
            child: const Text('Multifactor Methods'),
          ),
        ],
      ),
    );
  }
}
