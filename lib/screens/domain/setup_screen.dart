import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/config/app.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/text_field.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _SetupScreenState extends State<SetupScreen> {
  final registerDomainController = TextEditingController();
  int touchedTimes = 0;
  bool isLoading = false;
  String domainError = "";

  @override
  void dispose() {
    registerDomainController.dispose();
    super.dispose();
  }

  Future<bool> setup() async {
    setState(() {
      isLoading = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return false;
    }

    try {
      String rawDomain = registerDomainController.text.trim();
      // Strip any existing URL scheme to avoid double-prefixing
      rawDomain = rawDomain.replaceFirst(RegExp(r'^https?://'), '');
      // Keep only the host (and port), removing any path component
      rawDomain = rawDomain.split('/').first;

      final String scheme = environment == "local" ? "http://" : "https://";
      final String domain = "$scheme$rawDomain";

      await ApiService(domain).fetchData('api');
      await storeSetup(rawDomain);
      return true;
    } catch (e) {
      setState(() {
        domainError = "Your domain is not registered yet";
        isLoading = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      noAppBar: true,
      child: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 116, bottom: 58),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: 'setup_title'.tr,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: 8.0), // Add space between spans
                      ),
                      const TextSpan(
                        text: "LAKASIR",
                        style: TextStyle(color: primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: registerDomainController,
                      label: "setup_your_registered_domain".tr,
                      errorText: domainError,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "setup_please_enter_your_domain".tr;
                        }
                        return null;
                      },
                      mandatory: true,
                    ),
                  ),
                  MyFilledButton(
                    isLoading: isLoading,
                    onPressed: () {
                      setup().then(
                        (value) {
                          if (value) {
                            Get.offAllNamed('/auth');
                          } else {
                            show('Something went wrong', color: error);
                          }
                        },
                      );
                    },
                    child: const Text("Setup!"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 28, bottom: 58),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/domain/register');
                  },
                  child: SizedBox(
                    width: 300,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "setup_doesnt_have_domain".tr,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4.0)),
                          TextSpan(
                            text: "setup_please_create".tr,
                            style: const TextStyle(
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
