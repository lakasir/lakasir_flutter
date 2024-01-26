class CashierReportRequest {
  final String? startDate;
  final String? endDate;

  CashierReportRequest({
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  String toQuery() {
    return 'start_date=$startDate&end_date=$endDate';
  }
}
