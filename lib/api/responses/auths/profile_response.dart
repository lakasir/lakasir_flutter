class ProfileResponse {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String address;
  final String photoUrl;
  final String language;
  final String createdAt;
  final String updatedAt;

  ProfileResponse({
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.address,
    required this.photoUrl,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      name: json['name'],
      role: json['role'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      photoUrl: json['photo_url'],
      language: json['language'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
