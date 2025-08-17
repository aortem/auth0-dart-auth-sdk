// lib/pages/get_metadata_page.dart
import 'package:flutter/material.dart';
import 'package:auth0_dart_auth_sdk/auth0_dart_auth_sdk.dart';

class GetMetadataPage extends StatefulWidget {
  final String accessToken;
  final Uri auth0DomainUri;

  const GetMetadataPage({
    super.key,
    required this.accessToken,
    required this.auth0DomainUri,
  });

  @override
  State<GetMetadataPage> createState() => _GetMetadataPageState();
}

class _GetMetadataPageState extends State<GetMetadataPage> {
  String? metadataJson;
  String? error;

  Future<void> _fetchMetadata() async {
    setState(() {
      metadataJson = null;
      error = null;
    });

    try {
      final response = await auth0GetMetadata40(
        auth0DomainUri: widget.auth0DomainUri,
        request: Auth0GetMetadata40Request(accessToken: widget.accessToken),
      );
      setState(() {
        metadataJson = response.metadata.toString();
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Metadata')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchMetadata,
              child: const Text('Fetch Metadata'),
            ),
            const SizedBox(height: 20),
            if (metadataJson != null) SelectableText('Metadata: $metadataJson'),
            if (error != null)
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
