class ApiResponse<T> {
  bool success;
  String? message;
  T? data;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse<T>(
      success: json['success'],
      message: json['message'],
      data: fromJson(json['data']),
    );
  }
}

