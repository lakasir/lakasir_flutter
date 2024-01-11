import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/controllers/transactions/history_controller.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final _historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Transaction History",
      child: Obx(
        () {
          if (_historyController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: [
              for (var history in _historyController.histories)
                CardList(history: history),
            ],
          );
        },
      ),
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({
    super.key,
    required this.history,
  });

  final TransactionHistoryResponse history;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyCardList(
          onTap: () {
            Get.toNamed('/menu/transaction/history/detail', arguments: history);
          },
          list: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(history.date!),
                  ),
                ),
                Text(
                  "Total Qty: ${history.totalQuantity}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Total Price: ${formatPrice(history.totalPrice!, isSymbol: false)}",
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
