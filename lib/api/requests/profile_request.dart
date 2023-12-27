class ProfileRequest {
  String? name;
  String? email;
  String? phone;
  String? photoUrl;
  String? address;
  String? locale;

  ProfileRequest({
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.address,
    this.locale,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photo_url': photoUrl,
      'address': address,
      'locale': locale,
    };
  }
}
