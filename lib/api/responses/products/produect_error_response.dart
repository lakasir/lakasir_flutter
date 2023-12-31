class ProductErrorResponse {
  String? name;
  String? category;
  String? stock;
  String? initialPrice;
  String? sellingPrice;
  String? type;
  String? unit;
  String? photoUrl;

  ProductErrorResponse({
    this.name,
    this.category,
    this.stock,
    this.initialPrice,
    this.sellingPrice,
    this.type,
    this.unit,
    this.photoUrl,
  });

  ProductErrorResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'] == null ? '' : json['name'][0];
    category = json['category'] == null ? '' : json['category'][0];
    stock = json['stock'] == null ? '' : json['stock'][0];
    initialPrice = json['initial_price'] == null ? '' : json['initial_price'][0];
    sellingPrice = json['selling_price'] == null ? '' : json['selling_price'][0];
    type = json['type'] == null ? '' : json['type'][0];
    unit = json['unit'] == null ? '' : json['unit'][0];
    photoUrl = json['hero_images_url'] == null ? '' : json['hero_images_url'][0];
  }
}
