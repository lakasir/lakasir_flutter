class MemberResponse {
  int id;
  String name;
  String? code;
  String? address;
  String? email;
  final String createdAt;
  final String updatedAt;

  MemberResponse({
    required this.id,
    this.name = '',
    this.code = '',
    this.address = '',
    this.email = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory MemberResponse.fromJson(Map<String, dynamic> json) {
    return MemberResponse(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      email: json['email'],
    );
  }
}
