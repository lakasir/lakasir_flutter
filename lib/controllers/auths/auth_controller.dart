import 'package:get/get.dart';
import 'package:lakasir/controllers/profiles/profile_controller.dart';
import 'package:lakasir/utils/utils.dart';

class AuthController extends GetxController {
  RxList<String> permissions = List<String>.empty().obs;
  RxMap<String, bool> features = <String, bool>{}.obs;
  RxBool loading = false.obs;
  final ProfileController _profileController = Get.put(ProfileController());

  bool can({String? ability, String? feature}) {
    if (feature!.isEmpty) {
      return permissions.contains(ability);
    }

    return features[feature]! && permissions.contains(ability);
  }

  bool feature({String? feature}) {
    return features[feature]!;
  }

  void fetchPermissions() async {
    loading(true);
    await _profileController.getProfile();
    if (_profileController.profile.value.permissions != null) {
      permissions(_profileController.profile.value.permissions!);
    }
    if (_profileController.profile.value.features!.isNotEmpty) {
      Map<String, bool> validFeatures = _profileController
          .profile.value.features!
          .map((key, value) => MapEntry(key, value as bool));
      features.assignAll(validFeatures);

      // features(_profileController.profile.value.features);
    }
    loading(false);
  }
}
