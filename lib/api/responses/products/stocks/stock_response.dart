class StockResponse {
  final int id;
  final int productId;
  final int stock;
  final String type;
  final String createdAt;
  final String updatedAt;

  StockResponse({
    required this.id,
    required this.productId,
    required this.stock,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StockResponse.fromJson(Map<String, dynamic> json) {
    return StockResponse(
      id: json['id'],
      productId: json['product_id'],
      stock: json['stock'],
      type: json['type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
