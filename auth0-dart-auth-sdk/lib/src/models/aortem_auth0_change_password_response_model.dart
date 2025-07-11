/// Represents the response received from Auth0 after a password change request.
///
/// This class encapsulates the response message from Auth0's password change
/// endpoint, typically indicating success or providing error information.
class AortemAuth0ChangePasswordResponse {
  /// The message returned by Auth0, usually confirming the password change
  /// request or containing error details if the request failed.
  final String message;

  /// Creates an [AortemAuth0ChangePasswordResponse] instance.
  ///
  /// [message]: The response message from Auth0 (required).
  AortemAuth0ChangePasswordResponse({required this.message});

  /// Constructs an [AortemAuth0ChangePasswordResponse] from a JSON map.
  ///
  /// This factory method parses the response JSON received from Auth0's API
  /// and creates a corresponding response object.
  ///
  /// [json]: The JSON map containing the response data from Auth0.
  /// Returns an [AortemAuth0ChangePasswordResponse] with the parsed message.
  /// If 'message' field is missing in JSON, defaults to 'No message received'.
  factory AortemAuth0ChangePasswordResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AortemAuth0ChangePasswordResponse(
      message: json['message'] ?? 'No message received',
    );
  }
}
