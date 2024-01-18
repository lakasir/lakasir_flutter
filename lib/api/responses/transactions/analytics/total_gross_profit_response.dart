class TotalGrossProfitRespnose {
  double? totalGrossProfit;
  double? totalPreviousGrossProfit;
  int? percentageChange;

  TotalGrossProfitRespnose({
    this.totalGrossProfit,
    this.totalPreviousGrossProfit,
    this.percentageChange,
  });

  factory TotalGrossProfitRespnose.fromJson(Map<String, dynamic> json) {
    return TotalGrossProfitRespnose(
      totalGrossProfit: json['total_gross_profit'].toDouble(),
      totalPreviousGrossProfit: json['total_prevous_gross_profit'].toDouble(),
      percentageChange: json['percentage_change'],
    );
  }
}
