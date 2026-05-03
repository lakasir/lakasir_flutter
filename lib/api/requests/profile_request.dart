class ProfileRequest {
  String? name;
  String? email;
  String? phone;
  int? uploadedFileId;
  String? address;
  String? locale;

  ProfileRequest({
    this.name,
    this.email,
    this.phone,
    this.uploadedFileId,
    this.address,
    this.locale,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (uploadedFileId != null) 'uploaded_file_id': uploadedFileId,
      'address': address,
      'locale': locale,
    };
  }
}
