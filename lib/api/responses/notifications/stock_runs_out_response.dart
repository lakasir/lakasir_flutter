class StockRunsOut {
  int? id;
  String? name;
  String? stock;
  String? route;

  StockRunsOut({
    this.id,
    this.name,
    this.stock,
    this.route,
  });

  factory StockRunsOut.fromJson(Map<String, dynamic> json) {
    return StockRunsOut(
      id: json['id'],
      name: json['name'],
      stock: json['stock'],
      route: json['route'],
    );
  }
}
