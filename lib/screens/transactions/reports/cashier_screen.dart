import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/cashier_report_request.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/settings/secure_initial_price_controller.dart';
import 'package:lakasir/services/cashier_report_service.dart';
import 'package:lakasir/widgets/date_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_bottom_bar.dart';
import 'package:path_provider/path_provider.dart';

class CashierReportScreen extends StatefulWidget {
  const CashierReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CashierReportScreenState();
}

class _CashierReportScreenState extends State<CashierReportScreen> {
  final _cashierReportService = CashierReportService();
  final _cashierReportStartDateController = TextEditingController();
  final _cashierReportEndDateController = TextEditingController();

  bool _isLoading = false;

  Future<dynamic> _fetchCashierReport() async {
    String tzName = DateTime.now().timeZoneName;
    final response = await _cashierReportService.fetch(
      CashierReportRequest(
        startDate: "${_cashierReportStartDateController.text} $tzName",
        endDate: "${_cashierReportEndDateController.text} $tzName",
      ),
    );

    return response;
  }

  Future<File?> _generatePdfDocument(
    dynamic response,
  ) async {
    if (response.isNotEmpty) {
      final Directory? appDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      String tempPath = appDir!.path;
      final String fileName = "${DateTime.now().microsecondsSinceEpoch}.pdf";
      File file = File('$tempPath/$fileName');
      if (!await file.exists()) {
        await file.create();
      }
      await file.writeAsBytes(response);

      return file;
    }
    return null;
  }

  void _generateReport() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await _fetchCashierReport();
      final pdf = await _generatePdfDocument(response);
      setState(() {
        _isLoading = false;
      });
      if (pdf!.existsSync()) {
        Get.to(
          () => PdfPreviewScreen(pdfFile: pdf),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'transaction_cashier_report'.tr,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: MyDatePicker(
              usingTimePicker: true,
              // get yesterday
              initialDate: DateTime.now().subtract(const Duration(days: 5)),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              label: 'field_start_date'.tr,
              controller: _cashierReportStartDateController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: MyDatePicker(
              usingTimePicker: true,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              label: 'field_end_date'.tr,
              controller: _cashierReportEndDateController,
            ),
          ),
          MyFilledButton(
            onPressed: _generateReport,
            isLoading: _isLoading,
            child: Text('global_generate'.tr),
          ),
        ],
      ),
    );
  }
}

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({super.key, required this.pdfFile});

  final File pdfFile;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  final _secureInitialPriceController = Get.put(SecureInitialPriceController());
  final _settingController = Get.put(SettingController());
  // PDFViewController? _pdfViewController;
  final Duration initialDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    _secureInitialPriceController.isOpened.value = false;
    Timer(initialDuration, () {
      if (_settingController.setting.value.hideInitialPrice!) {
        _secureInitialPriceController.verifyPassword();
        // _secureInitialPriceController.isOpened.value = true;
        // isVisible = true;
      }
    });
    super.initState();
  }

  void _downloadPdf() async {
    try {
      String fileName = "${DateTime.now().microsecondsSinceEpoch}.pdf";
      String path = "/storage/emulated/0/Download/$fileName";
      File file = File(path);
      if (!await file.exists()) {
        await file.create();
      }
      file.writeAsBytesSync(await widget.pdfFile.readAsBytes());
      Get.rawSnackbar(
        message: 'global_success_download'.tr,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var isOpen = _settingController.setting.value.hideInitialPrice! &&
            !_secureInitialPriceController.isOpened.value;

        return Visibility(
          visible: !isOpen,
          child: Layout(
            bottomNavigationBar: MyBottomBar(
              singleAction: true,
              singleActionOnPressed: _downloadPdf,
              singleActionIcon: Icons.download,
            ),
            title: 'transaction_cashier_report'.tr,
            child: PDFView(
              swipeHorizontal: true,
              filePath: widget.pdfFile.path,
              onError: (error) {
                debugPrint(error.toString());
              },
              onPageError: (page, error) {
                debugPrint('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) async {
                setState(() {
                  // _pdfViewController = pdfViewController;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
