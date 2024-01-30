import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/product_stock_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/pagination_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';
import 'package:lakasir/utils/auth.dart';

class ProductStockService {
  Future<PaginationResponse<StockResponse>> get(int id) async {
    final response = await ApiService(await getDomain()).fetchData(
      'master/product/$id/stock',
    );

    final apiResponse = ApiResponse.fromJson(response, (contentJson) {
      return PaginationResponse<StockResponse>.fromJson(
        contentJson,
        (dataJson) {
          return StockResponse.fromJson(dataJson);
        },
      );
    });

    return apiResponse.data?.value ?? PaginationResponse();
  }

  Future<void> create(int id, ProductStockRequest? productStockRequest) async {
    await ApiService(await getDomain()).postData(
      'master/product/$id/stock',
      productStockRequest?.toJson(),
    );
  }

  Future<void> delete(int id, int stockId) async {
    await ApiService(await getDomain()).deleteData(
      'master/product/$id/stock/$stockId',
    );
  }
}
