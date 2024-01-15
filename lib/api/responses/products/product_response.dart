import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';

class ProductResponse {
  final int id;
  final String name;
  final String type;
  final String unit;
  final String? image;
  final double? initialPrice;
  final double? sellingPrice;
  final int? stock;
  final int? categoryId;
  final String? createdAt;
  final String? updatedAt;
  final CategoryResponse? category;
  final List<StockResponse>? stocks;

  ProductResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.unit,
    this.image,
    this.initialPrice,
    this.sellingPrice,
    this.stock,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.stocks,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final heroImages = json['hero_images'] as List;

    return ProductResponse(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      unit: json['unit'],
      image: heroImages.firstOrNull,
      initialPrice: json['initial_price'].toDouble(),
      sellingPrice: json['selling_price'].toDouble(),
      stock: json['stock'],
      categoryId: json['category_id'],
      category: json['category'] != null
          ? CategoryResponse.fromJson(json['category'])
          : null,
      stocks: json['stocks'] != null
          ? (json['stocks'] as List)
              .map((e) => StockResponse.fromJson(e))
              .toList()
          : [],
    );
  }
}
