import 'package:get/get.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/utils/auth.dart';

class CategoryService {
  CategoryService();

  Future<RxList<CategoryResponse>> getCategories() async {
    final response =
        await ApiService(await getDomain()).fetchData('master/category');
    final apiResponse = ApiResponse.fromJsonList(response, (json) {
      return RxList<CategoryResponse>.from(
          json.map((x) => CategoryResponse.fromJson(x)));
    });

    return apiResponse.data!.value;
  }

  Future<void> addCategory(String name) async {
    await ApiService(await getDomain()).postData('master/category', {
      'name': name,
    });
  }

  Future<void> deleteCategory(int id) async {
    await ApiService(await getDomain()).deleteData('master/category/$id');
  }
}
