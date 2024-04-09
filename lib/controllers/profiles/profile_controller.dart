import 'package:get/get.dart';
import 'package:lakasir/api/responses/auths/profile_response.dart';
import 'package:lakasir/services/profile_service.dart';

class ProfileController extends GetxController {
  Rx<ProfileResponse> profile = ProfileResponse().obs;
  final ProfileService _profileService = ProfileService();
  Rx<bool> isLoading = false.obs;

  Future<void> getProfile() async {
    isLoading(true);
    final response = await _profileService.get();
    profile(response);
    update();
    isLoading(false);
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}
