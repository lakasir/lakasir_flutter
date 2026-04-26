import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/login_request.dart';
import 'package:lakasir/api/responses/auths/login_error_response.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/offline/services/connectivity_service.dart';
import 'package:lakasir/offline/services/offline_user_service.dart';
import 'package:lakasir/services/login_service.dart';
import 'package:lakasir/utils/auth.dart';

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
        try {
          await _loginOnline();
          return;
        } catch (e) {
          await _loginOfflineFallback();
          return;
        }
      } else {
        await _loginOfflineFallback();
      }
    } catch (e) {
      isLoading(false);
    }
  }

  Future<void> _loginOnline() async {
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
    final appMode = Get.find<AppModeService>();
    await appMode.switchToOnline();
    Get.offAllNamed('/auth');
  }

  Future<void> _loginOffline() async {
    final userService = OfflineUserService();
    await userService.login(
      email: emailController.text,
      password: passwordController.text,
    );
    isLoading(false);
    clearError();
    clearInput();
    final appMode = Get.find<AppModeService>();
    appMode.switchToOffline();
    Get.offAllNamed('/auth');
  }

  Future<void> _loginOfflineFallback() async {
    final userService = OfflineUserService();
    await userService.login(
      email: emailController.text,
      password: passwordController.text,
    );
    isLoading(false);
    clearError();
    clearInput();
    final appMode = Get.find<AppModeService>();
    appMode.switchToOffline();
    Get.offAllNamed('/auth');
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