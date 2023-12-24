class MemberErrorResponse {
  String name;
  String? email;

  MemberErrorResponse({
    required this.name,
    this.email,
  });

  factory MemberErrorResponse.fromJson(Map<String, dynamic> json) {
    return MemberErrorResponse(
      name: json['name'] == null ? '' : json['name'][0],
      email: json['email'] == null ? '' : json['email'][0],
    );
  }
}
