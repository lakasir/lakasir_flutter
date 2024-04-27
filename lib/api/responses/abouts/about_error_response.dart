class AboutErrorResponse {
  final String? businessType;
  final String? otherBusinesType;

  AboutErrorResponse({
    this.businessType,
    this.otherBusinesType,
  });

  factory AboutErrorResponse.fromJson(Map<String, dynamic> json) {
    return AboutErrorResponse(
      businessType:
          json['business_type'] == null ? '' : json['business_type'][0],
      otherBusinesType: json['other_business_type'] == null
          ? ''
          : json['other_business_type'][0],
    );
  }
}
