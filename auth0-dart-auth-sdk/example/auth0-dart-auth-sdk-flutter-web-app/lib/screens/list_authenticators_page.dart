import 'package:auth0_dart_auth_sdk_flutter_test_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class ListAuthenticatorsPage extends StatefulWidget {
  final String accessToken;

  const ListAuthenticatorsPage({super.key, required this.accessToken});

  @override
  State<ListAuthenticatorsPage> createState() => _ListAuthenticatorsPageState();
}

class _ListAuthenticatorsPageState extends State<ListAuthenticatorsPage> {
  List<Auth0Authenticator> authenticators = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchAuthenticators();
  }

  Future<void> _fetchAuthenticators() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final request = Auth0ListAuthenticatorsRequest(widget.accessToken);
      final service = Auth0ListAuthenticators(
        auth0Domain: AUTH0_DOMAIN,
        accessToken: widget.accessToken,
      );
      final response = await service.fetchAuthenticators(request);

      setState(() {
        authenticators = response.authenticators;
      });
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

  Future<void> _deleteAuthenticator(String authenticatorId) async {
    final client = Auth0DeleteAuthenticatorClient(auth0Domain: AUTH0_DOMAIN);

    final request = Auth0DeleteAuthenticatorRequest(
      accessToken: widget.accessToken,
      authenticatorId: authenticatorId,
    );

    try {
      final response = await client.deleteAuthenticator(request);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      // Refresh list after deletion
      _fetchAuthenticators();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete authenticator: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enrolled Authenticators')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('Error: $error'))
          : authenticators.isEmpty
          ? const Center(child: Text('No authenticators found.'))
          : ListView.builder(
              itemCount: authenticators.length,
              itemBuilder: (context, index) {
                final auth = authenticators[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.security),
                    title: Text(auth.name),
                    subtitle: Text('Type: ${auth.type}\nID: ${auth.id}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmation(auth.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(String authenticatorId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
          'Are you sure you want to delete this authenticator?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAuthenticator(authenticatorId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
