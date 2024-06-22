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
  final double? discount;
  final double? discountPrice;
  final int? stock;
  final int? categoryId;
  final String? createdAt;
  final String? updatedAt;
  final bool isNonStock;
  final String sku;
  final String? barcode;
  final CategoryResponse? category;
  final List<StockResponse>? stocks;

  ProductResponse({
    this.id = 0,
    this.name = '',
    this.type = 'product',
    this.unit = '',
    this.isNonStock = false,
    this.sku = '',
    this.barcode,
    this.image,
    this.initialPrice,
    this.sellingPrice,
    this.discount,
    this.discountPrice,
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
      sku: json['sku'] ?? '',
      barcode: json['barcode'],
      isNonStock: json['is_non_stock'] ?? false,
      type: json['type'],
      unit: json['unit'],
      image: heroImages.firstOrNull,
      initialPrice: json['initial_price'].toDouble(),
      sellingPrice: json['selling_price'].toDouble(),
      // initialPrice: json['initial_price'].toDouble(),
      // sellingPrice: json['selling_price'].toDouble(),
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
