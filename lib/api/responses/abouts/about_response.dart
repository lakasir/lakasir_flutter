class AboutResponse {
  final String shopeName;
  final String businessType;
  final String ownerName;
  final String location;
  final String currency;

  AboutResponse({
    required this.shopeName,
    required this.businessType,
    required this.ownerName,
    required this.location,
    required this.currency,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) {
    return AboutResponse(
      shopeName: json['shope_name'],
      businessType: json['business_type'],
      ownerName: json['owner_name'],
      location: json['location'],
      currency: json['currency'],
    );
  }
}
