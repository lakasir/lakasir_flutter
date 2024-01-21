class TotalGrossProfitRespnose {
  double totalGrossProfit;
  double totalPreviousGrossProfit;
  int percentageChange;

  TotalGrossProfitRespnose({
    this.totalGrossProfit = 0,
    this.totalPreviousGrossProfit = 0,
    this.percentageChange = 0,
  });

  factory TotalGrossProfitRespnose.fromJson(Map<String, dynamic> json) {
    return TotalGrossProfitRespnose(
      totalGrossProfit: json['total_gross_profit'].toDouble(),
      totalPreviousGrossProfit: json['total_prevous_gross_profit'].toDouble(),
      percentageChange: json['percentage_change'],
    );
  }
}
