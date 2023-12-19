class LoginErrorResponse {
  String email;
  String password;
  LoginErrorResponse({required this.email, required this.password});

  factory LoginErrorResponse.fromJson(Map<String, dynamic> json) {
    return LoginErrorResponse(
      email: json['email'] == null ? '' : json['email'][0],
      password: json['password'] == null ? '' : json['password'][0],
    );
  }
}
