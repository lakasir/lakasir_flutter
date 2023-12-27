class ProfileResponse {
  final String? name;
  final String? roles;
  final String? email;
  final String? phone;
  final String? address;
  String? photoUrl;
  final String? locale;
  final String? createdAt;
  final String? updatedAt;

  ProfileResponse({
    this.name,
    this.roles,
    this.email,
    this.phone,
    this.address,
    this.photoUrl,
    this.locale,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo'],
      address: json['address'],
      roles: json['roles'],
      locale: json['locale'] ?? 'en',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
