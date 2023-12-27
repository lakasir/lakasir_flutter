class ProfileErrorResponse {
  String name;
  String phone;
  String email;
  String address;
  String locale;
  String photoUrl;

  ProfileErrorResponse({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.locale = '',
    this.photoUrl = '',
  });

  factory ProfileErrorResponse.fromJson(Map<String, dynamic> json) {
    return ProfileErrorResponse(
      phone: json["phone"] == null ? '' : json["phone"][0],
      name: json["name"] == null ? '' : json["name"][0],
      email: json['email'] == null ? '' : json['email'][0],
      address: json["address"] == null ? '' : json["address"][0],
      locale: json["locale"] == null ? '' : json["locale"][0],
      photoUrl: json["photo_url"] == null ? '' : json["photo_url"][0],
    );
  }
}
