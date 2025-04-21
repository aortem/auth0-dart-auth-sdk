class AortemAuth0MultifactorVerifyException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? details;

  AortemAuth0MultifactorVerifyException({
    required this.message,
    required this.statusCode,
    this.details,
  });

  @override
  String toString() => 'AortemAuth0Exception($statusCode): $message';
}
