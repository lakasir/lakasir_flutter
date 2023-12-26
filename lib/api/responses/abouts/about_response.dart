class AboutResponse {
  String? shopeName;
  String? businessType;
  String? ownerName;
  String? location;
  String? currency;
  String? photo;

  AboutResponse({
    required this.shopeName,
    required this.businessType,
    required this.ownerName,
    required this.location,
    required this.currency,
    required this.photo,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) {
    return AboutResponse(
      shopeName: json['shop_name'],
      businessType: json['business_type'],
      ownerName: json['owner_name'],
      location: json['shop_location'],
      currency: json['currency'],
      photo: json['photo_url'],
    );
  }
}
