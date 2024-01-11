import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/build_list_image.dart';
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
    TransactionHistoryResponse history = Get.arguments;
    return Layout(
      title: "Transaction Detail",
      child: ListView(
        children: [
          const SizedBox(height: 10),
          ...headerDetail(history),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              "Products",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...List.generate(
            history.sellingDetails!.length,
            (index) {
              final sellingDetail = history.sellingDetails![index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: MyCardList(
                  key: ValueKey(sellingDetail.id),
                  list: [
                    Text(
                      sellingDetail.product!.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Quantity: ${sellingDetail.quantity}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      "Total Sub price: ${formatPrice(sellingDetail.price)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                  imagebox: Hero(
                    tag: 'product-${sellingDetail.product!.id}',
                    child: BuildListImage(
                      url: sellingDetail.product!.image,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Container> headerDetail(TransactionHistoryResponse history) {
    return [
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Code:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    history.code!,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Quantity:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(history.totalQuantity.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    DateFormat('dd-MM-yyyy HH:mm')
                        .format(DateTime.parse(history.createdAt!))
                        .toString(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Price:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(formatPrice(history.totalPrice!)),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Member:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    history.member == null
                        ? "Non Member"
                        : history.member!.name,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payed Money:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(formatPrice(history.payedMoney!)),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Method:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(history.paymentMethod!.name),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Money Changes:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(formatPrice(history.moneyChange!)),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Friend Price:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(history.friendPrice ? "Yes" : "No"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tax:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text("${history.tax!}%"),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
