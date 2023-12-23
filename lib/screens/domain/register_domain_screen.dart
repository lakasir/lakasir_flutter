import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/responses/domain/register_error_response.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/config/app.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/checkbox.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';

class RegisterDomainScreen extends StatefulWidget {
  const RegisterDomainScreen({super.key});
  @override
  State<RegisterDomainScreen> createState() => _RegisterDomainScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RegisterDomainScreenState extends State<RegisterDomainScreen> {
  final fullNameController = TextEditingController();
  final domainNameController = TextEditingController();
  final emailOrPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  bool agree = false;
  bool isLoading = false;
  RegisterErrorResponse registerErrorResponse = RegisterErrorResponse(
    shopName: "",
    fullName: "",
    domainName: "",
    emailOrPhone: "",
    password: "",
  );

  Future<String> register() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (!agree) {
        throw Exception("Please agree to our terms and conditions");
      }
      if (!_formKey.currentState!.validate()) {
        setState(() {
          isLoading = false;
        });
        throw Exception("Please fill the form correctly");
      }

      await ApiService(baseUrl).postData(
        'domain/register',
        {
          "full_name": fullNameController.text,
          "domain": domainNameController.text,
          "email": emailOrPhoneController.text,
          "password": passwordController.text,
          "password_confirmation": passwordConfirmationController.text,
        },
      );

      return "";
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is ValidationException) {
        ErrorResponse<RegisterErrorResponse> errorResponse =
            ErrorResponse.fromJson(jsonDecode(e.toString()),
                (json) => RegisterErrorResponse.fromJson(json));

        setState(() {
          registerErrorResponse = errorResponse.errors!;
        });
        return errorResponse.message;
      }

      return e.toString().replaceAll("Exception: ", "");
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    domainNameController.dispose();
    emailOrPhoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroudWhite,
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            // wellcome text
            Container(
              margin: const EdgeInsets.only(top: 80, bottom: 35),
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(color: Colors.black),
                      ),
                      WidgetSpan(
                        child: SizedBox(width: 8.0), // Add space between spans
                      ),
                      TextSpan(
                        text: "LAKASIR",
                        style: TextStyle(color: primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: fullNameController,
                        errorText: registerErrorResponse.shopName,
                        label: "Shop Name",
                        mandatory: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: domainNameController,
                        errorText: registerErrorResponse.domainName,
                        prefixText:
                            environment == "local" ? "http://" : "https://",
                        info:
                            "Your domain should be using your shop name, for example: yourshopname.lakasir.com",
                        label: "Domain Name",
                        mandatory: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: emailOrPhoneController,
                        errorText: registerErrorResponse.emailOrPhone,
                        label: "Email",
                        mandatory: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: passwordController,
                        errorText: registerErrorResponse.password,
                        label: "Password",
                        mandatory: true,
                        obscureText: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: passwordConfirmationController,
                        label: "Password Confirmation",
                        mandatory: true,
                        obscureText: true,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyCheckbox(
                        label:
                            "By creating the shop, you agree to our Terms and Conditions",
                        onChange: (bool value) {
                          setState(() {
                            agree = value;
                          });
                        },
                      ),
                    ),
                    MyFilledButton(
                      isLoading: isLoading,
                      onPressed: () {
                        register().then((value) {
                          if (value.isEmpty) {
                            Get.rawSnackbar(
                              title:
                                  "Register Success, check your email to get more information of your shop",
                              backgroundColor: success,
                            );
                            Get.offAllNamed("/auth");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(value),
                                backgroundColor: error,
                              ),
                            );
                          }
                        });
                      },
                      child: const Text("Create Your Shop"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
