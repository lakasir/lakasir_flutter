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
      title: "transaction_detail".tr,
      child: ListView(
        children: [
          const SizedBox(height: 10),
          ...headerDetail(history),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              "menu_product".tr,
              style: const TextStyle(
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
                      "${sellingDetail.quantity} x ${formatPrice(sellingDetail.price / sellingDetail.quantity)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      "field_subtotal".trParams(
                        {
                          "price": formatPrice(sellingDetail.price),
                        },
                      ),
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
                  Text(
                    "${"field_code".tr}:",
                    style: const TextStyle(
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
                  Text(
                    "${"field_total_quantity".tr}:",
                    style: const TextStyle(
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
                  Text(
                    "${"field_date".tr}:",
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    DateFormat('dd-MM-yyyy HH:mm')
                        .format(DateTime.parse(history.createdAt!).toLocal())
                        .toString(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${"field_total_price".tr}:",
                    style: const TextStyle(
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
                  Text(
                    "${"field_member".tr}:",
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    history.member == null
                        ? "global_no_item".trParams(
                            {"item": "menu_member".tr},
                          )
                        : history.member!.name,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${"field_payed_money".tr}:",
                    style: const TextStyle(
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
                  Text(
                    "${"field_payment_method".tr}:",
                    style: const TextStyle(
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
                  Text(
                    "${"field_change".tr}:",
                    style: const TextStyle(
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
                  Text(
                    "${"field_friend_price".tr}:",
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(history.friendPrice ? "global_yes".tr : "global_no".tr),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "field_tax".tr,
                    style: const TextStyle(
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
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${"field_customer_number".tr}:",
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    history.customerNumber == null
                        ? "global_no_item".trParams(
                            {"item": "field_customer_number".tr},
                          )
                        : history.customerNumber.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
