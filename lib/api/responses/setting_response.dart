class SettingResponse {
  String? key;
  String? value;

  SettingResponse({this.key, this.value});

  factory SettingResponse.fromJson(Map<String, dynamic> json) {
    return SettingResponse(
      key: json['key'],
      value: json['value'],
    );
  }
}

class Setting {
  String? currency;
  String? locale;
  String? sellingMethod;
  bool cashDrawerEnabled;
  bool? hideInitialPrice;
  bool? hideInitialPriceUsingPin;
  double? defaultTax;

  Setting({
    this.currency,
    this.locale,
    this.sellingMethod,
    this.cashDrawerEnabled = false,
    this.hideInitialPrice = false,
    this.hideInitialPriceUsingPin = false,
    this.defaultTax = 0,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      currency: json["currency"],
      locale: json["locale"],
      sellingMethod: json["selling_method"],
      cashDrawerEnabled: json["cash_drawer_enabled"],
      hideInitialPrice: json["secure_initial_price_enabled"],
      hideInitialPriceUsingPin: json["secure_initial_price_using_pin"],
      defaultTax:
          json["default_tax"] == null ? 0 : json["default_tax"].toDouble(),
    );
  }
}
