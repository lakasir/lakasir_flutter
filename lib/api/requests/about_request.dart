class AboutRequest {
  final String? shopName;
  final String? shopLocation;
  final String? businessType;
  final String? photoUrl;
  final String? ownerName;

  AboutRequest({
    this.shopName,
    this.shopLocation,
    this.businessType,
    this.photoUrl,
    this.ownerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'shop_name': shopName,
      'shop_location': shopLocation,
      'business_type': businessType,
      'photo_url': photoUrl ?? '',
      'owner_name': ownerName,
    };
  }
}
