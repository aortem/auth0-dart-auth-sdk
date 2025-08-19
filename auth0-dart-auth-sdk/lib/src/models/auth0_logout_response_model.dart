/// Represents the response containing the generated Auth0 logout URL.
class Auth0LogoutResponse {
  /// The logout URL to which the user should be redirected.
  final String logoutUrl;

  ///constructure
  Auth0LogoutResponse({required this.logoutUrl}) {
    if (logoutUrl.trim().isEmpty) {
      throw ArgumentError('Logout URL must not be empty.');
    }
  }

  /// Converts the response to JSON.
  Map<String, dynamic> toJson() {
    return {'logout_url': logoutUrl};
  }

  /// Creates a response instance from JSON.
  factory Auth0LogoutResponse.fromJson(Map<String, dynamic> json) {
    return Auth0LogoutResponse(logoutUrl: json['logout_url']);
  }

  @override
  String toString() {
    return 'Auth0LogoutResponse(logoutUrl: $logoutUrl)';
  }
}
