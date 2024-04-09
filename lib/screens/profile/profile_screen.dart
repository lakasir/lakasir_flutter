import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/profiles/profile_controller.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';

String Function(String) locale = (String locale) {
  switch (locale) {
    case 'en_US':
      return 'English';
    case 'id_ID':
      return 'Indonesia';
    default:
      return 'English';
  }
};

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());
  String _locale = 'en_US';

  @override
  initState() {
    super.initState();
    getLanguageCode().then((value) {
      setState(() {
        _locale = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      noAppBar: true,
      noPadding: true,
      child: Obx(
        () {
          if (_profileController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      title: Center(
                        child: Text(
                          'menu_profile'.tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      expandedHeight: MediaQuery.of(context).size.height * 0.5,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: const BoxDecoration(
                            color: primary,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () {
                                      Widget photo = const Icon(
                                        Icons.person,
                                        size: 100,
                                        color: primary,
                                      );
                                      if (_profileController
                                              .profile.value.photoUrl !=
                                          null) {
                                        photo = Image.network(
                                          _profileController
                                                  .profile.value.photoUrl
                                                  ?.replaceFirst(
                                                      "https", "http") ??
                                              "",
                                          fit: BoxFit.cover,
                                        );
                                      }

                                      return Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, left: 50),
                                        width: 160,
                                        height: 160,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: photo,
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/menu/profile/edit',
                                        arguments:
                                            _profileController.profile.value,
                                      );
                                    },
                                    icon: const Icon(
                                      size: 30,
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                _profileController.profile.value.name ?? "-",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'field_role_user'.tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _profileController.profile.value.roles ?? "-",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "field_email".tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _profileController.profile.value.email ?? "-",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "field_phone".tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _profileController.profile.value.phone ?? "-",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "field_address".tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _profileController.profile.value.address ?? "-",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "field_language".tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                locale(_locale),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 2,
                          width: double.infinity,
                          color: whiteGrey,
                          margin: const EdgeInsets.only(bottom: 10),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                logout().then((value) {
                                  Get.offAllNamed('/auth');
                                });
                              },
                              child: Text(
                                "logout".tr,
                                style: const TextStyle(color: primary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
