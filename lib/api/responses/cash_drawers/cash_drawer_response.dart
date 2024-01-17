class CashDrawerResponse {
  int? id;
  int? openedBy;
  int? closedBy;
  double? cash;

  CashDrawerResponse({
    this.id,
    this.openedBy,
    this.closedBy,
    this.cash,
  });

  factory CashDrawerResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    return CashDrawerResponse(
      id: json['id'],
      openedBy: json['opened_by'],
      closedBy: json['closed_by'],
      cash: json['cash'].toDouble(),
    );
  }
}
