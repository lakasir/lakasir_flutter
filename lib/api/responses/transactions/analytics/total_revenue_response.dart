class TotalRevenueResponse {
  double? totalRevenue;
  double? totalPreviousRevenue;
  int? percentageChange;

  TotalRevenueResponse({
    this.totalRevenue,
    this.totalPreviousRevenue,
    this.percentageChange,
  });

  factory TotalRevenueResponse.fromJson(Map<String, dynamic> json) {
    // {total_revenue: 50000, total_prevous_revenue: 24500, percentage_change: 104}
    // print(json);
    return TotalRevenueResponse(
      totalRevenue: json["total_revenue"].toDouble(),
      totalPreviousRevenue: json["total_prevous_revenue"].toDouble(),
      percentageChange: json["percentage_change"],
    );
  }
}
