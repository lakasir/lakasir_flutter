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
  String? methodePrice;
  bool cashDrawerEnabled;
  bool? hideInitialPrice;
  bool? hideInitialPriceUsingPin;

  Setting({
    this.currency,
    this.locale,
    this.methodePrice,
    this.cashDrawerEnabled = false,
    this.hideInitialPrice = false,
    this.hideInitialPriceUsingPin = false,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      currency: json["currency"],
      locale: json["locale"],
      methodePrice: json["methode_price"],
      cashDrawerEnabled: json["cash_drawer_enabled"],
      hideInitialPrice: json["secure_initial_price_enabled"],
      hideInitialPriceUsingPin: json["secure_initial_price_using_pin"],
    );
  }
}
