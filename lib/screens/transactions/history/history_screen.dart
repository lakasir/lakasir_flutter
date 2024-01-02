import 'package:flutter/material.dart';
import 'package:lakasir/api/responses/categories/category_response.dart';
import 'package:lakasir/api/responses/members/member_response.dart';
import 'package:lakasir/api/responses/products/product_response.dart';
import 'package:lakasir/api/responses/products/stocks/stock_response.dart';
import 'package:lakasir/api/responses/transactions/history_response.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:lakasir/widgets/layout.dart';
import 'package:lakasir/widgets/my_card_list.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final List<TransactionHistoryResponse> histories = [
    TransactionHistoryResponse(
      id: 1,
      date: "20-10-2021",
      items: "3 Items",
      total: 100000,
      productId: 1,
      moneyBack: 5000,
      moneyPaid: 10000,
      member: MemberResponse(
        id: 1,
        name: "Member 1",
        code: "XL20190",
        address: "lorem ipsum",
        createdAt: "2021-10-20T07:00:00.000000Z",
        updatedAt: "2021-10-20T07:00:00.000000Z",
        email: '',
      ),
      products: [
        ProductResponse(
          id: 1,
          name: 'Cashier',
          type: "Product",
          unit: "pcs",
          image:
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          initialPrice: 5200,
          sellingPrice: 5500,
          stock: 100,
          categoryId: 1,
          createdAt: '2021-10-10',
          updatedAt: '2021-10-10',
          category: CategoryResponse(
            id: 1,
            name: 'Food',
            createdAt: '2021-10-10',
            updatedAt: '2021-10-10',
          ),
          stocks: [
            StockResponse(
              id: 1,
              stock: 100,
              type: 'add',
              date: '2021-10-10',
            ),
          ],
        ),
      ],
      createdAt: "2021-10-20T07:00:00.000000Z",
      updatedAt: "2021-10-20T07:00:00.000000Z",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Transaction History",
      child: ListView(
        children: [
          for (var history in histories) CardList(history: history),
        ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: MyCardList(
        onTap: () {
          Navigator.pushNamed(context, '/menu/transaction/history/detail',
              arguments: history);
        },
        list: [
          Text(
            history.date,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            history.items,
            style: const TextStyle(
              fontWeight: FontWeight.w200,
            ),
          ),
          Text(
            formatPrice(history.total),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
