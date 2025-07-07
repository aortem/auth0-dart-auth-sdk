/// Represents the logout request payload for Auth0.
class AortemAuth0LogoutRequest {
  /// The client ID of the Auth0 application.
  final String clientId;

  /// Optional: The URL to redirect to after logout.
  final String? returnTo;

  /// Optional: Whether to log the user out from federated identity providers.
  final bool? federated;

  ///Construcutre
  AortemAuth0LogoutRequest({
    required this.clientId,
    this.returnTo,
    this.federated,
  }) {
    if (clientId.trim().isEmpty) {
      throw ArgumentError('Client ID must not be empty.');
    }
  }

  /// Converts this request into a query parameters map.
  Map<String, String> toQueryParams() {
    final params = <String, String>{
      'client_id': clientId,
    };

    if (returnTo != null && returnTo!.trim().isNotEmpty) {
      params['returnTo'] = returnTo!;
    }
    if (federated == true) {
      params['federated'] = 'true';
    }

    return params;
  }

  /// Optional: Convert to JSON if needed in other contexts
  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      if (returnTo != null) 'return_to': returnTo,
      if (federated != null) 'federated': federated,
    };
  }
}
