class PaymentMethodRespone {
  int id;
  String name;
  String? icon;
  bool isCash;
  bool isDebit;
  bool isCredit;
  bool isWallet;

  PaymentMethodRespone({
    required this.id,
    required this.name,
    this.icon,
    this.isCash = false,
    this.isDebit = false,
    this.isCredit = false,
    this.isWallet = false,
  });

  factory PaymentMethodRespone.fromJson(Map<String, dynamic> json) {
    return PaymentMethodRespone(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      isCash: json['is_cash'] == 0 ? false : true,
      isDebit: json['is_debit'] == 0 ? false : true,
      isCredit: json['is_credit'] == 0 ? false : true,
      isWallet: json['is_wallet'] == 0 ? false : true,
    );
  }
}
