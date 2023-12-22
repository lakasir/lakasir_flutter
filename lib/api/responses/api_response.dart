class DataWrapper<T> {
  final T value;

  DataWrapper(this.value);
}

class ApiResponse<T> {
  bool success;
  String? message;
  DataWrapper<T>? data;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ApiResponse<T>(
      success: json['success'],
      message: json['message'],
      data: DataWrapper(fromJson(json['data'])),
    );
  }

  factory ApiResponse.fromJsonList(
    Map<String, dynamic> json,
    T Function(List) fromJson,
  ) {
    return ApiResponse<T>(
      success: json['success'],
      message: json['message'],
      data: DataWrapper(fromJson(json['data'])),
    );
  }
}
