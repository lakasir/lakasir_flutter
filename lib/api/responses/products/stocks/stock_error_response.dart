class StockErrorResponse {
  String? stock;
  String? initialPrice;
  String? sellingPrice;

  StockErrorResponse({
    this.stock,
    this.initialPrice,
    this.sellingPrice,
  });

  StockErrorResponse.fromJson(Map<String, dynamic> json) {
    stock = json['stock'] == null ? '' : json['stock'][0];
    initialPrice = json['initial_price'] == null ? '' : json['initial_price'][0];
    sellingPrice = json['selling_price'] == null ? '' : json['selling_price'][0];
  }
}

