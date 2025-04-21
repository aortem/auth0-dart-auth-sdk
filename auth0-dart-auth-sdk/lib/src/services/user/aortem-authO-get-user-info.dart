import 'dart:convert';
import 'package:auth0_dart_auth_sdk/src/exceptions/aortem-autho-get_user_info_exception.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_get_user_info_request.dart';
import 'package:auth0_dart_auth_sdk/src/models/aortem_auth0_get_user_info_response.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Fetches user information from Auth0 using the /userinfo endpoint.
Future<AortemAuth0GetUserInfoResponse> aortemAuth0GetUserInfo({
  required String domain,
  required AortemAuth0GetUserInfoRequest request,
  Duration timeout = const Duration(seconds: 10),
}) async {
  final uri = Uri.https(domain, '/userinfo');

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer ${request.accessToken}',
      'Content-Type': 'application/json',
    },
  ).timeout(timeout);

  if (response.statusCode == 200) {
    try {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      return AortemAuth0GetUserInfoResponse.fromJson(jsonBody);
    } catch (e) {
      throw AortemAuth0UserInfoException(
          'Failed to parse user info response: $e');
    }
  } else {
    String errorMessage = 'Failed to fetch user info';
    try {
      final errorJson = json.decode(response.body);
      if (errorJson is Map && errorJson.containsKey('error_description')) {
        errorMessage = errorJson['error_description'];
      }
    } catch (_) {}
    throw AortemAuth0UserInfoException(errorMessage, response.statusCode);
  }
}
