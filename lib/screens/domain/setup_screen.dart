import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/config/app.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
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
  String baseDomain = ".lakasir.com";

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
      String domain = "https://${registerDomainController.text}";
      if (environment == "local") {
        domain = "http://${registerDomainController.text}";
      }
      domain = domain + baseDomain;

      await ApiService(domain).fetchData('api');
      await storeSetup(registerDomainController.text + baseDomain);
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
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      touchedTimes++;
                    });

                    if (touchedTimes == 5) {
                      var snackBar = SnackBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        dismissDirection: DismissDirection.none,
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.only(bottom: 15),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        content: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xff656565),
                            ),
                            child: const Text('Using your own domain'),
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        baseDomain = "";
                      });
                    }
                  },
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
                          child:
                              SizedBox(width: 8.0), // Add space between spans
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
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      prefixText:
                          environment == "local" ? "http://" : "https://",
                      suffixText: baseDomain,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong"),
                                backgroundColor: error,
                              ),
                            );
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
