class ProfileResponse {
  final int? id;
  final String? name;
  final String? roles;
  final String? email;
  final String? phone;
  final String? address;
  String? photoUrl;
  final String? locale;
  final String? createdAt;
  final String? updatedAt;
  final List<String>? permissions;
  final Map<String, dynamic>? features;
  final bool? isOwner;

  ProfileResponse({
    this.id,
    this.name,
    this.roles,
    this.permissions,
    this.email,
    this.phone,
    this.address,
    this.photoUrl,
    this.locale,
    this.createdAt,
    this.updatedAt,
    this.features,
    this.isOwner,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo'],
      address: json['address'],
      roles: json['roles'],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
      features: json['features'],
      locale: json['locale'] ?? 'en',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isOwner: json['is_owner'],
    );
  }
}
