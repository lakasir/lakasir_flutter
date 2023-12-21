class ForgotPasswordErrorResponse {
  ForgotPasswordErrorResponse({
    required this.email,
  });

  String email;

  factory ForgotPasswordErrorResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordErrorResponse(
      email: json['email'] == null ? '' : json['email'][0],
    );
  }
}
