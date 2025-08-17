import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class GetUserInfoTestScreen extends StatefulWidget {
  const GetUserInfoTestScreen({super.key});

  @override
  State<GetUserInfoTestScreen> createState() => _GetUserInfoTestScreenState();
}

class _GetUserInfoTestScreenState extends State<GetUserInfoTestScreen> {
  final _accessTokenController = TextEditingController();
  final _domainController = TextEditingController(text: AUTH0_DOMAIN);

  String _status = '';
  Auth0GetUserInfoResponse? _userInfo;
  bool _loading = false;

  Future<void> _fetchUserInfo() async {
    setState(() {
      _loading = true;
      _status = '';
      _userInfo = null;
    });

    try {
      final request = Auth0GetUserInfoRequest(
        accessToken: _accessTokenController.text.trim(),
      );

      final result = await auth0GetUserInfo(
        domain: _domainController.text.trim(),
        request: request,
      );

      setState(() {
        _userInfo = result;
        _status = '✅ User info retrieved successfully';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildUserInfoCard() {
    if (_userInfo == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_userInfo!.picture != null)
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(_userInfo!.picture!),
                ),
              ),
            const SizedBox(height: 10),
            Text('User ID: ${_userInfo!.sub}'),
            if (_userInfo!.name != null) Text('Name: ${_userInfo!.name}'),
            if (_userInfo!.email != null) Text('Email: ${_userInfo!.email}'),
            const Divider(),
            Text(
              'Additional Claims:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_userInfo!.additionalClaims.toString()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth0 Get User Info Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                labelText: 'Auth0 Domain',
                hintText: 'e.g. your-tenant.auth0.com',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _accessTokenController,
              decoration: const InputDecoration(labelText: 'Access Token'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _fetchUserInfo,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Fetch User Info'),
            ),
            const SizedBox(height: 20),
            Text(_status),
            _buildUserInfoCard(),
          ],
        ),
      ),
    );
  }
}
