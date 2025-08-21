import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';
// auth0-dart-auth-sdk\lib\src\request_handling\auth0_accept_request.dart
import 'package:auth0_dart_auth_sdk/src/request_handling/auth0_accept_request.dart';

class AcceptRequestPage extends StatefulWidget {
  final String ticket;
  final String clientId;
  final String auth0Domain;

  const AcceptRequestPage({
    super.key,
    required this.ticket,
    required this.clientId,
    required this.auth0Domain,
  });

  @override
  State<AcceptRequestPage> createState() => _AcceptRequestPageState();
}

class _AcceptRequestPageState extends State<AcceptRequestPage> {
  bool isLoading = false;
  String? error;
  Auth0AcceptRequestResponse? response;

  @override
  void initState() {
    super.initState();
    _acceptMagicLinkRequest();
  }

  Future<void> _acceptMagicLinkRequest() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // final ticket = Uri.base.queryParameters['ticket'];

      final client = Auth0AcceptRequestClient(auth0Domain: widget.auth0Domain);

      final request = Auth0AcceptRequestRequest(
        clientId: widget.clientId,
        ticket: widget.ticket,
      );

      final res = await client.acceptRequest(request);

      setState(() {
        response = res;
      });

      // TODO: Save tokens to secure storage or pass to authenticated screens
      print('Access Token: ${res.accessToken}');
      print('ID Token: ${res.idToken}');
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildResult() {
    if (error != null) {
      return Text('❌ Error: $error');
    }
    if (response == null) {
      return const Text('Waiting for response...');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '✅ Login Successful',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Access Token: ${response!.accessToken}'),
        const SizedBox(height: 8),
        Text('ID Token: ${response!.idToken}'),
        if (response!.refreshToken != null)
          Text('Refresh Token: ${response!.refreshToken}'),
        const SizedBox(height: 8),
        Text('Token Type: ${response!.tokenType}'),
        if (response!.expiresIn != null)
          Text('Expires In: ${response!.expiresIn} seconds'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accept Magic Link")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading ? const CircularProgressIndicator() : _buildResult(),
        ),
      ),
    );
  }
}
