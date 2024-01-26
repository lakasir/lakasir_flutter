import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/api/requests/cashier_report_request.dart';
import 'package:lakasir/api/responses/api_response.dart';
import 'package:lakasir/api/responses/transactions/reports/cashier_report_response.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Transaction {
  final Map<String, dynamic> transaction;
  final Map<String, dynamic> total;

  Transaction({required this.transaction, required this.total});
}

class CashierReportService {
  Future<dynamic> fetch(
    CashierReportRequest cashierReportRequest,
  ) async {
    final response = await ApiService(await getDomain()).fetchByte(
      'report/cashier',
      cashierReportRequest.toJson(),
    );

    return response;
  }

  Future<pw.Document> generateCashierReport(
    List<CashierReportResponse> response,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        clip: true,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                'transaction_cashier_report'.tr,
                style: pw.TextStyle(
                  fontSize: 30,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Toko Nafissah',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Periode : ',
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "2024-01-01 00:00:00",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    ' - ',
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "2024-01-01 00:00:00",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(
                height: 20,
              ),
              for (var items in response)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 20),
                  child: pw.Column(
                    children: [
                      pw.TableHelper.fromTextArray(
                        cellAlignment: pw.Alignment.centerLeft,
                        cellAlignments: {0: pw.Alignment.centerLeft},
                        headers: [
                          'Kasir',
                          'No. Transaksi',
                          'Tanggal dan jam',
                          'Itmes',
                          'Biaya Modal',
                          'Keuntungan Kotor',
                          'Keuntungan Bersih',
                        ],
                        data: List<List<dynamic>>.generate(
                          items.transaction!.items!.length,
                          (row) => [
                            row == 0 ? items.transaction!.user : '',
                            row == 0 ? items.transaction!.number : '',
                            // y-M-d
                            row == 0
                                ? DateFormat('y-M-d H:mm:s').format(
                                    DateTime.parse(items.transaction!.date!)
                                        .toLocal(),
                                  )
                                : '',
                            '${items.transaction!.items![row].product!} x ${items.transaction!.items![row].quantity}',
                            formatPrice(items.transaction!.items![row].cost,
                                isSymbol: false),
                            formatPrice(items.transaction!.items![row].price,
                                isSymbol: false),
                            formatPrice(
                                items.transaction!.items![row].netProfit,
                                isSymbol: false),
                          ],
                        ),
                      ),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.black,
                          ),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Total',
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              formatPrice(
                                items.total!.totalNetProfit,
                                isSymbol: false,
                              ),
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}
