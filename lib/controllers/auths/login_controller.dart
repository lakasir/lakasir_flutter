import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/login_request.dart';
import 'package:lakasir/api/responses/auths/login_error_response.dart';
import 'package:lakasir/api/responses/error_response.dart';
import 'package:lakasir/services/login_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final remember = false.obs;
  final isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<LoginErrorResponse> loginErrorResponse = LoginErrorResponse(
    password: "",
    email: "",
  ).obs;
  final LoginService _loginService = LoginService();

  Future<void> login() async {
    try {
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }

      await _loginService.login(
        LoginRequest(
          email: emailController.text,
          password: passwordController.text,
          remember: remember.value,
        ),
      );
      isLoading(false);
      clearError();
      clearInput();
      Get.offAllNamed('/auth');
    } catch (e) {
      if (e is ValidationException) {
        ErrorResponse<LoginErrorResponse> errorResponse =
            ErrorResponse.fromJson(jsonDecode(e.toString()),
                (json) => LoginErrorResponse.fromJson(json));

        loginErrorResponse.value = errorResponse.errors!;
      }
      isLoading(false);
    }
  }

  void clearError() {
    loginErrorResponse.value = LoginErrorResponse();
  }

  void clearInput() {
    emailController.clear();
    passwordController.clear();
    remember.value = false;
  }
}
