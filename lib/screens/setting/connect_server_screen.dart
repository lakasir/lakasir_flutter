import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/offline/services/app_mode_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectServerScreen extends StatefulWidget {
  const ConnectServerScreen({super.key});

  @override
  State<ConnectServerScreen> createState() => _ConnectServerScreenState();
}

class _ConnectServerScreenState extends State<ConnectServerScreen> {
  final _domainController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (_domainController.text.isEmpty) {
      setState(() => errorMessage = 'Domain is required');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final domain = _domainController.text.trim();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('domain', domain);
      await prefs.setBool('setup', true);

      final appMode = Get.find<AppModeService>();
      await appMode.switchToOnline();

      Get.offAllNamed('/auth');
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('connect_to_server'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 80,
              color: primary,
            ),
            const SizedBox(height: 24),
            Text(
              'connect_to_server_description'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            MyTextField(
              controller: _domainController,
              hintText: 'https://your-domain.com',
              label: 'Domain',
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: error),
                ),
              ),
            const SizedBox(height: 24),
            MyFilledButton(
              onPressed: isLoading ? () {} : _connect,
              isLoading: isLoading,
              child: Text('connect_to_server'.tr),
            ),
          ],
        ),
      ),
    );
  }
}