import 'package:get/get.dart';
import 'package:lakasir/controllers/profiles/profile_controller.dart';

class AuthController extends GetxController {
  RxList<String> permissions = List<String>.empty().obs;
  RxBool loading = false.obs;
  final ProfileController _profileController = Get.put(ProfileController());

  bool can(String ability) {
    return permissions.contains(ability);
  }

  void fetchPermissions() async {
    loading(true);
    await _profileController.getProfile();
    if (_profileController.profile.value.permissions != null) {
      permissions(_profileController.profile.value.permissions!);
    }
    loading(false);
  }
}
