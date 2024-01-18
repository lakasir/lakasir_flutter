import 'package:get/get.dart';
import 'package:lakasir/api/responses/transactions/analytics/total_gross_profit_response.dart';
import 'package:lakasir/api/responses/transactions/analytics/total_revenue_response.dart';
import 'package:lakasir/api/responses/transactions/analytics/total_sales_response.dart';
import 'package:lakasir/services/analytics_service.dart';

class AnalyticsController extends GetxController {
  final _analyticsService = AnalyticsService();
  final Rx<TotalRevenueResponse> totalRevenue = TotalRevenueResponse().obs;
  RxBool isTotalRevenueLoading = false.obs;
  final Rx<TotalSalesResponse> totalSales = TotalSalesResponse().obs;
  RxBool isTotalSalesLoading = false.obs;
  final Rx<TotalGrossProfitRespnose> totalGrossProfit =
      TotalGrossProfitRespnose().obs;
  RxBool isTotalGrossProfitLoading = false.obs;

  void fetchTotalRevenue({String filterType = "today"}) async {
    isTotalRevenueLoading.value = true;
    totalRevenue.value = await _analyticsService.fetchTotalRevenue(filterType);
    isTotalRevenueLoading.value = false;
  }

  void fetchTotalSales({String filterType = "today"}) async {
    isTotalSalesLoading.value = true;
    totalSales.value = await _analyticsService.fetchTotalSales(filterType);
    isTotalSalesLoading.value = false;
  }

  void fetchTotalGrossProfit({String filterType = "today"}) async {
    isTotalGrossProfitLoading.value = true;
    totalGrossProfit.value = await _analyticsService.fetchTotalGrossProfit(filterType);
    isTotalGrossProfitLoading.value = false;
  }
  
  @override
  void onInit() {
    fetchTotalRevenue();
    fetchTotalSales();
    fetchTotalGrossProfit();
    super.onInit();
  }
}
