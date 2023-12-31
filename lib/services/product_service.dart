import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/product_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/pagination_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/utils/auth.dart';

class ProductService {
  Future<PaginationResponse<ProductResponse>> get(ProductRequest? productRequest) async {
    final response = await ApiService(await getDomain()).fetchData(
      'master/product?${productRequest?.toQuery()}',
    );

    final apiResponse = ApiResponse.fromJson(response, (contentJson) {
      return PaginationResponse<ProductResponse>.fromJson(
        contentJson,
        (dataJson) {
          return ProductResponse.fromJson(dataJson);
        },
      );
    });

    return apiResponse.data?.value ?? PaginationResponse();
  }

  Future<void> create(ProductRequest productRequest) async {
    await ApiService(await getDomain()).postData(
      'master/product',
      productRequest.toJson(),
    );
  }

  Future<void> update(int id, ProductRequest productRequest) async {
    await ApiService(await getDomain()).putData(
      'master/product/$id',
      productRequest.toJson(),
    );
  }

  Future<void> delete(int id) async {
    await ApiService(await getDomain()).deleteData(
      'master/product/$id',
    );
  }

  Future<ProductResponse> getById(int id) async {
    final response = await ApiService(await getDomain()).fetchData(
      'master/product/$id',
    );

    final apiResponse = ApiResponse.fromJson(response, (contentJson) {
      return ProductResponse.fromJson(contentJson);
    });

    return Future.value(apiResponse.data?.value);
  }
}
