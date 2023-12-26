import 'package:get/get.dart';
import 'package:lakasir/api/responses/abouts/about_response.dart';
import 'package:lakasir/services/about_service.dart';

class AboutController extends GetxController {
  Rx<AboutResponse> shop = AboutResponse(
    shopeName: '',
    businessType: '',
    ownerName: '',
    location: '',
    currency: '',
    photo: '',
  ).obs;
  RxBool isLoading = false.obs;

  AboutService aboutService = AboutService();

  Future<void> getShop() async {
    isLoading(true);
    final response = await aboutService.get();
    shop.value = response;
    isLoading(false);
  }

  @override
  void onInit() {
    super.onInit();
    getShop();
  }
}
