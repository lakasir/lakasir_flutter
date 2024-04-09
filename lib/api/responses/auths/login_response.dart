class LoginResponse {
  final String token;
  final List<String> permissions;

  LoginResponse({required this.token, required this.permissions});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      permissions:
          (json['permissions'] as List).map((item) => item as String).toList(),
    );
  }
}
