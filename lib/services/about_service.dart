import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/about_request.dart';
import 'package:lakasir/api/responses/abouts/about_response.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/utils/auth.dart';

class AboutService {
  Future<AboutResponse> get() async {
    final response = await ApiService(await getDomain()).fetchData('about');
    final apiResponse = ApiResponse.fromJson(
      response,
      (json) {
        return AboutResponse.fromJson(json);
      },
    );

    return apiResponse.data!.value;
  }

  Future<void> update(AboutRequest data) async {
    await ApiService(await getDomain()).putData('about', data.toJson());
  }
}
