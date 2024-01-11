class RegisterErrorResponse {
  String shopName;
  String fullName;
  String domainName;
  String emailOrPhone;
  String password;
  String? businessType;

  RegisterErrorResponse({
    required this.shopName,
    required this.fullName,
    required this.domainName,
    required this.emailOrPhone,
    required this.password,
    required this.businessType,
  });

  factory RegisterErrorResponse.fromJson(Map<String, dynamic> json) {
    return RegisterErrorResponse(
      shopName: json['shop_name'] == null ? '' : json['shop_name'][0],
      fullName: json['full_name'] == null ? '' : json['full_name'][0],
      domainName: json['domain_name'] == null ? '' : json['domain_name'][0],
      emailOrPhone: json['email_or_phone'] == null ? '' : json['email_or_phone'][0],
      password: json['password'] == null ? '' : json['password'][0],
      businessType: json['business_type'] == null ? '' : json['business_type'][0],
    );
  }
}

