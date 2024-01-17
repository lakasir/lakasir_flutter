class CashDrawerRequest {
  double? cash;

  CashDrawerRequest({
    this.cash,
  });

  Map<String, dynamic> toJson() {
    return {
      'cash': cash,
    };
  }
}
