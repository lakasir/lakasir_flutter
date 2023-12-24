class MemberRequest {
  final String name;
  final String address;
  final String code;
  final String email;

  MemberRequest({
    required this.name,
    required this.address,
    required this.code,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'code': code,
      'email': email,
    };
  }
}

