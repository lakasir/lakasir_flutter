import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/login_request.dart';
import 'package:lakasir/api/responses/auths/login_error_response.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/connectivity_service.dart';
import 'package:lakasir/offline/services/offline_user_service.dart';
import 'package:lakasir/services/login_service.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/utils.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final remember = false.obs;
  final isLoading = false.obs;
  final isOfflineLogin = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<LoginErrorResponse> loginErrorResponse = LoginErrorResponse(
    password: "",
    email: "",
  ).obs;
  final LoginService _loginService = LoginService();

  @override
  void onInit() {
    super.onInit();
    _detectMode();
  }

  Future<void> _detectMode() async {
    final offline = await isOfflineMode();
    if (offline) {
      isOfflineLogin.value = true;
      return;
    }

    final hasDomainFlag = await hasDomain();
    if (!hasDomainFlag) {
      isOfflineLogin.value = true;
      return;
    }

    final connectivity = Get.find<ConnectivityService>();
    final connected = await connectivity.checkConnection();
    isOfflineLogin.value = !connected;
  }

  Future<void> login() async {
    try {
      isLoading(true);
      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }

      final offline = await isOfflineMode();
      if (offline) {
        await _loginOffline();
        return;
      }

      final hasDomainFlag = await hasDomain();
      if (!hasDomainFlag) {
        await _loginOffline();
        return;
      }

      final connectivity = Get.find<ConnectivityService>();
      final connected = await connectivity.checkConnection();

      if (connected) {
        await _loginOnline();
      } else {
        await _loginOfflineFallback();
      }
    } catch (e) {
      isLoading(false);
      debug(e);
      rethrow;
    }
  }

  Future<void> _loginOnline() async {
    try {
      await _loginService.login(
        LoginRequest(
          email: emailController.text,
          password: passwordController.text,
          remember: remember.value,
        ),
      );
      clearError();
      clearInput();
      final appMode = Get.find<AppModeService>();
      await appMode.switchToOnline();
      Get.offAllNamed('/auth');
    } on ValidationException catch (e) {
      loginErrorResponse.value = LoginErrorResponse.fromJson(
        jsonDecode(e.message),
      );
    } catch (e) {
      debug(e);
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loginOffline() async {
    try {
      final userService = OfflineUserService();
      await userService.login(
        email: emailController.text,
        password: passwordController.text,
      );
      clearError();
      clearInput();
      final appMode = Get.find<AppModeService>();
      appMode.switchToOffline();
      Get.offAllNamed('/auth');
    } catch (e) {
      debug(e);
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loginOfflineFallback() async {
    try {
      final userService = OfflineUserService();
      await userService.login(
        email: emailController.text,
        password: passwordController.text,
      );
      clearError();
      clearInput();
      final appMode = Get.find<AppModeService>();
      appMode.switchToOffline();
      Get.offAllNamed('/auth');
    } catch (e) {
      debug(e);
      rethrow;
    } finally {
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

