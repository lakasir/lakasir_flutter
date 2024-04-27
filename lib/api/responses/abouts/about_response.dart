class AboutResponse {
  String? shopeName;
  String? businessType;
  String? ownerName;
  String? location;
  String? currency;
  String? photo;
  String? otherBusinessType;

  AboutResponse({
    this.shopeName,
    this.businessType,
    this.otherBusinessType,
    this.ownerName,
    this.location,
    this.currency,
    this.photo,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) {
    return AboutResponse(
      shopeName: json['shop_name'],
      businessType: json['business_type'],
      otherBusinessType: json['other_business_type'],
      ownerName: json['owner_name'],
      location: json['shop_location'],
      currency: json['currency'],
      photo: json['photo_url'],
    );
  }
}
