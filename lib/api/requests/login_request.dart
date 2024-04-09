class LoginRequest {
  final String? password;
  final String? email;
  final bool remember;

  LoginRequest({
    this.password,
    this.email,
    this.remember = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'email': email,
      'remember': remember,
    };
  }
}
