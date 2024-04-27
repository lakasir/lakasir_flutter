class AboutRequest {
  final String? shopName;
  final String? shopLocation;
  final String? businessType;
  final String? otherBusinessType;
  final String? photoUrl;
  final String? ownerName;

  AboutRequest({
    this.shopName,
    this.shopLocation,
    this.businessType,
    this.otherBusinessType,
    this.photoUrl,
    this.ownerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'shop_name': shopName,
      'shop_location': shopLocation,
      'business_type': businessType,
      'other_business_type': otherBusinessType,
      'photo_url': photoUrl ?? '',
      'owner_name': ownerName,
    };
  }
}
