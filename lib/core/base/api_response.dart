class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final T? data;
  final String? errorMessage;
  final Map<String, dynamic>? rawJson;
 
  const ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.errorMessage,
    this.rawJson,
  });
 
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
}