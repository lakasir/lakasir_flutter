import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/controllers/transactions/history_controller.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _historyController = Get.put(HistoryController());
  final PagingController<int, TransactionHistoryResponse> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) async {
      await _historyController.fetchTransaction(
        PaginationRequest(
          page: pageKey + 1,
          perPage: _historyController.perPage,
        ),
      );
      final isLastPage =
          _historyController.histories.length < _historyController.perPage;
      if (isLastPage) {
        _pagingController.appendLastPage(_historyController.histories);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
          _historyController.histories,
          nextPageKey,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Transaction History",
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<TransactionHistoryResponse>(
          itemBuilder: (context, history, index) => CardList(
            history: history,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
                  DateFormat('dd-MM-yyyy HH:mm')
                      .format(DateTime.parse(history.createdAt!))
                      .toString(),
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
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
