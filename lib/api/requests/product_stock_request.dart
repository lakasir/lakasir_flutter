class ProductStockRequest {
  final int stock;
  final String? type;
  final String? date;
  final String? initialPrice;
  final String? sellingPrice;

  ProductStockRequest({
    required this.stock,
    this.type,
    this.date,
    this.initialPrice,
    this.sellingPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'stock': stock,
      'type': type,
      'date': date,
      'initial_price': initialPrice,
      'selling_price': sellingPrice,
    };
  }
}
