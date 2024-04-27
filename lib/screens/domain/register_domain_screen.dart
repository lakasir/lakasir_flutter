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
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/select_input_feld.dart';
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
  final businessTypeController = SelectInputWidgetController();
  final otherInput = TextEditingController();
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
    businessType: "",
    otherBusinessType: "",
  );
  bool showOtherInput = false;

  Future<String> register() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (!agree) {
        throw Exception("please_agree".tr);
      }
      if (!_formKey.currentState!.validate()) {
        setState(() {
          isLoading = false;
        });
        throw Exception("please_fill_form".tr);
      }

      await ApiService(baseUrl).postData(
        'api/domain/register',
        {
          "full_name": fullNameController.text,
          "domain": "${domainNameController.text}.lakasir.com",
          "email": emailOrPhoneController.text,
          "password": passwordController.text,
          "password_confirmation": passwordConfirmationController.text,
          "business_type": businessTypeController.selectedOption,
          "other_business_type": otherInput.text,
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
    businessTypeController.selectedOption = "";
    super.dispose();
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
            // wellcome text
            Container(
              margin: const EdgeInsets.only(top: 80, bottom: 35),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "sign_up".tr,
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
                      controller: fullNameController,
                      errorText: registerErrorResponse.shopName,
                      label: "field_shop_name".tr,
                      mandatory: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: SelectInputWidget(
                      options: [
                        Option(
                            name: "field_option_retail_business_type".tr,
                            value: "retail"),
                        Option(
                            name: "field_option_wholesale_business_type".tr,
                            value: "wholesale"),
                        Option(
                            name: "field_option_fnb_business_type".tr,
                            value: "fnb"),
                        Option(
                            name: "field_option_fashion_business_type".tr,
                            value: "fashion"),
                        Option(
                            name: "field_option_pharmacy_business_type".tr,
                            value: "pharmacy"),
                        Option(
                            name: "field_option_other_business_type".tr,
                            value: "other"),
                      ],
                      controller: businessTypeController,
                      label: "field_business_type".tr,
                      mandatory: true,
                      errorText: registerErrorResponse.businessType,
                      onChanged: (String value) async {
                        setState(() {
                          showOtherInput = value == 'other';
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: showOtherInput,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 21.0),
                      child: MyTextField(
                        controller: otherInput,
                        errorText: registerErrorResponse.otherBusinessType,
                        label: "field_option_other_business_type".tr,
                        mandatory: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: domainNameController,
                      errorText: registerErrorResponse.domainName,
                      prefixText:
                          environment == "local" ? "http://" : "https://",
                      info: "info_domain".tr,
                      label: "field_domain_name".tr,
                      suffixText: ".lakasir.com",
                      mandatory: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: emailOrPhoneController,
                      errorText: registerErrorResponse.emailOrPhone,
                      label: "field_email".tr,
                      mandatory: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      controller: passwordController,
                      errorText: registerErrorResponse.password,
                      label: "field_password".tr,
                      mandatory: true,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyTextField(
                      textInputAction: TextInputAction.done,
                      controller: passwordConfirmationController,
                      label: "field_password_confirmation".tr,
                      mandatory: true,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 21.0),
                    child: MyCheckbox(
                      label: "agreement_sentence".tr,
                      onChange: (bool value) {
                        setState(() {
                          agree = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 58),
                    child: MyFilledButton(
                      isLoading: isLoading,
                      onPressed: () {
                        register().then((value) {
                          if (value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Text("register_success".tr),
                                backgroundColor: success,
                              ),
                            );
                            Get.back();
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
