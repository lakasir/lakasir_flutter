import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/offline/models/offline_payment_method_model.dart';
import 'package:lakasir/offline/services/offline_permission_service.dart';
import 'package:lakasir/offline/services/offline_user_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterOfflineUserScreen extends StatefulWidget {
  const RegisterOfflineUserScreen({super.key});

  @override
  State<RegisterOfflineUserScreen> createState() =>
      _RegisterOfflineUserScreenState();
}

class _RegisterOfflineUserScreenState extends State<RegisterOfflineUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final shopNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    shopNameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final userService = OfflineUserService();
      await userService.register(
        name: fullNameController.text,
        email: emailController.text,
        password: passwordController.text,
        shopName: shopNameController.text,
      );

      await _seedDefaultPaymentMethods();
      await _seedDefaultPermissions();
      // Store setup directly without clearing offline auth
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('setup', true);
      await prefs.setString('domain', 'offline');

      if (mounted) {
        Get.offAllNamed('/auth');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> _seedDefaultPaymentMethods() async {
    final isar = LakasirDatabase.isar;
    final defaults = [
      OfflinePaymentMethod()
        ..name = 'Cash'
        ..isCash = true
        ..isLocal = true,
      OfflinePaymentMethod()
        ..name = 'Debit'
        ..isDebit = true
        ..isLocal = true,
      OfflinePaymentMethod()
        ..name = 'Credit'
        ..isCredit = true
        ..isLocal = true,
      OfflinePaymentMethod()
        ..name = 'E-Wallet'
        ..isWallet = true
        ..isLocal = true,
    ];

    await isar.writeTxn(() async {
      for (final pm in defaults) {
        await isar.offlinePaymentMethods.put(pm);
      }
    });
  }

  Future<void> _seedDefaultPermissions() async {
    final permissionService = OfflinePermissionService();
    await permissionService.seedDefaultPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      noAppBar: true,
      resizeToAvoidBottomInset: true,
      child: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 10),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 35),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "create_your_shop".tr,
                        style: const TextStyle(color: Colors.black),
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
                      controller: shopNameController,
                      label: "field_shop_name".tr,
                      mandatory: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: fullNameController,
                      label: "field_full_name".tr,
                      mandatory: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: emailController,
                      label: "field_email".tr,
                      mandatory: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: passwordController,
                      label: "field_password".tr,
                      mandatory: true,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: passwordConfirmationController,
                      label: "field_password_confirmation".tr,
                      mandatory: true,
                      obscureText: true,
                    ),
                  ),
                  if (errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: error, fontSize: 14),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 58),
                    child: MyFilledButton(
                      isLoading: isLoading,
                      onPressed: _register,
                      child: Text("create_your_shop".tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}