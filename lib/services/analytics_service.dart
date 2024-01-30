import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/transactions/analytics/total_gross_profit_response.dart';
import 'package:lakasir/api/responses/transactions/analytics/total_revenue_response.dart';
import 'package:lakasir/api/responses/transactions/analytics/total_sales_response.dart';
import 'package:lakasir/utils/auth.dart';

class AnalyticsService {
  Future<TotalRevenueResponse> fetchTotalRevenue(String filterType) async {
    String tzName = DateTime.now().timeZoneName;
    final response = await ApiService(await getDomain()).fetchData(
        'transaction/dashboard/total-revenue?filter_type=$filterType&timezone=$tzName');

    final apiResponse = ApiResponse.fromJson(response, (json) {
      return TotalRevenueResponse.fromJson(json);
    });

    return apiResponse.data!.value;
  }

  Future<TotalGrossProfitRespnose> fetchTotalGrossProfit(
      String filterType) async {
    String tzName = DateTime.now().timeZoneName;
    final response = await ApiService(await getDomain()).fetchData(
        'transaction/dashboard/total-gross-profit?filter_type=$filterType&timezone=$tzName');

    final apiResponse = ApiResponse.fromJson(response, (json) {
      return TotalGrossProfitRespnose.fromJson(json);
    });

    return apiResponse.data!.value;
  }

  Future<TotalSalesResponse> fetchTotalSales(String filterType) async {
    String tzName = DateTime.now().timeZoneName;
    final response = await ApiService(await getDomain()).fetchData(
        'transaction/dashboard/total-sales?filter_type=$filterType&timezone=$tzName');

    final apiResponse = ApiResponse.fromJson(response, (json) {
      return TotalSalesResponse.fromJson(json);
    });

    return apiResponse.data!.value;
  }
}
