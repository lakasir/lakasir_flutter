class TotalSalesResponse {
  double totalSales;
  double totalPreviousSales;
  int percentageChange;

  TotalSalesResponse({
    this.totalSales = 0,
    this.totalPreviousSales = 0,
    this.percentageChange = 0,
  });

  factory TotalSalesResponse.fromJson(Map<String, dynamic> json) {
    return TotalSalesResponse(
      totalSales: json["total_sales"].toDouble(),
      totalPreviousSales: json["total_prevous_sales"].toDouble(),
      percentageChange: json["percentage_change"],
    );
  }
}
