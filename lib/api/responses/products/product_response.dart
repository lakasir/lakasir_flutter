import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';

class ProductResponse {
  final int id;
  final String name;
  final String description;
  final String type;
  final String unit;
  final String image;
  final double initialPrice;
  final double sellingPrice;
  final int stock;
  final int categoryId;
  final String createdAt;
  final String updatedAt;
  final CategoryResponse? category;
  final List<StockResponse>? stocks;

  ProductResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.unit,
    required this.image,
    required this.initialPrice,
    required this.sellingPrice,
    required this.stock,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.stocks,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      unit: json['unit'],
      image: json['image'],
      initialPrice: json['initial_price'].toDouble(),
      sellingPrice: json['selling_price'].toDouble(),
      stock: json['stock'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: json['category'] != null
          ? CategoryResponse.fromJson(json['category'])
          : null,
      stocks: json['stocks'] != null
          ? (json['stocks'] as List)
              .map((e) => StockResponse.fromJson(e))
              .toList()
          : null,
    );
  }
}
