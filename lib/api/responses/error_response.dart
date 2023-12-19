class ErrorResponse<T> {
  final String message;
  final T? errors;

  ErrorResponse({required this.message, this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ErrorResponse<T>(
      message: json['message'],
      errors: fromJson!(json['errors']),
    );
  }
}
