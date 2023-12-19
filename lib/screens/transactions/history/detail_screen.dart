import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionHistoryResponse history = ModalRoute.of(context)!
        .settings
        .arguments as TransactionHistoryResponse;
    return Layout(
      title: "Transaction History Detail",
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2,
              children: [
                MyCardList(
                  list: [
                    const Text(
                      "Date",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      history.date,
                    ),
                  ],
                ),
                MyCardList(
                  list: [
                    const Text(
                      "Money Change",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(history.date),
                  ],
                ),
                MyCardList(
                  list: [
                    const Text(
                      "Member",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(history.member!.name),
                  ],
                ),
                MyCardList(
                  list: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(formatPrice(history.total)),
                  ],
                ),
                MyCardList(
                  list: [
                    const Text(
                      "Money Paid",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(formatPrice(history.moneyPaid)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
