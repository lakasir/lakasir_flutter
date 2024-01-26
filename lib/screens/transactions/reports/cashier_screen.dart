import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:lakasir/api/requests/cashier_report_request.dart';
import 'package:lakasir/api/responses/transactions/reports/cashier_report_response.dart';
import 'package:lakasir/controllers/setting_controller.dart';
import 'package:lakasir/controllers/settings/secure_initial_price_controller.dart';
import 'package:lakasir/services/cashier_report_service.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/widgets/date_picker.dart';
import 'package:lakasir/widgets/filled_button.dart';
import 'package:lakasir/widgets/layout.dart';
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
  final _secureInitialPriceController = Get.put(SecureInitialPriceController());
  final _settingController = Get.put(SettingController());

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
          () => PdfPreviewScreen(
            path: pdf.path,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
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
  const PdfPreviewScreen({super.key, required this.path});

  final String path;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      noAppBar: true,
      child: PDFView(
        filePath: widget.path,
        autoSpacing: false,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (_pages) {
          print("OK RENDERED!!!!!");
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // _controller.complete(pdfViewController);
        },
        onLinkHandler: (String? uri) {
          print('goto uri: $uri');
        },
        onPageChanged: (int? page, int? total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
