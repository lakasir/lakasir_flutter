import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/auths/login_controller.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/checkbox.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Layout(
      resizeToAvoidBottomInset: true,
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
                        text: "sign_in".tr,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: 8.0),
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
            Obx(
              () => _loginController.isOfflineLogin.value
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primary, width: 1),
                          ),
                          child: Text(
                            'offline_mode'.tr,
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Form(
              key: _loginController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: Obx(
                      () => MyTextField(
                        controller: _loginController.emailController,
                        errorText:
                            _loginController.loginErrorResponse.value.email,
                        label: "field_email".tr,
                        mandatory: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: Obx(
                      () => MyTextField(
                        errorText:
                            _loginController.loginErrorResponse.value.password,
                        controller: _loginController.passwordController,
                        label: "field_password".tr,
                        mandatory: true,
                        obscureText: true,
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: Obx(
                      () => Visibility(
                        visible: !_loginController.isOfflineLogin.value,
                        maintainState: false,
                        maintainSize: false,
                        maintainAnimation: false,
                        child: MyCheckbox(
                          label: "field_remember_me".tr,
                          onChange: (bool value) {
                            _loginController.remember.value = value;
                          },
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => MyFilledButton(
                      isLoading: _loginController.isLoading.value,
                      onPressed: () async {
                        await _loginController.login();
                      },
                      child: Text(
                        _loginController.isOfflineLogin.value
                            ? "${"sign_in".tr} (${"offline_mode".tr})"
                            : "sign_in".tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: !_loginController.isOfflineLogin.value,
                maintainState: false,
                maintainSize: false,
                maintainAnimation: false,
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot');
                      },
                      child: Text(
                        "forgot_password".tr,
                        style: const TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}